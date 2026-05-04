#!/bin/bash

# ============================================
# AWS Fintech ATM Simulation System
# Author: Blessing Rakoma
# Withdrawal Script with Fraud Detection - withdraw.sh
# ============================================

S3_BUCKET="s3://atm-simulation-bucket"
ACCOUNT_FILE="/tmp/account.txt"
LOG_FILE="/tmp/transaction.log"
WITHDRAWAL_LIMIT=5000  # Maximum allowed withdrawal per transaction

# Load current balance from S3
aws s3 cp $S3_BUCKET/account.txt $ACCOUNT_FILE --quiet
CURRENT_BALANCE=$(cat $ACCOUNT_FILE)

echo ""
echo "============================================"
echo "   💸 Withdrawal"
echo "============================================"
echo "  Current Balance: R$CURRENT_BALANCE"
echo "  Withdrawal Limit per Transaction: R$WITHDRAWAL_LIMIT"
echo "============================================"
read -p "  Enter withdrawal amount (R): " AMOUNT

# Validate: amount must be a positive number
if ! [[ "$AMOUNT" =~ ^[0-9]+(\.[0-9]+)?$ ]] || [ $(echo "$AMOUNT <= 0" | bc) -eq 1 ]; then
  echo "  ❌ Invalid amount. Please enter a positive number."
  exit 1
fi

# Fraud Check 1: Withdrawal limit per transaction
if [ $(echo "$AMOUNT > $WITHDRAWAL_LIMIT" | bc) -eq 1 ]; then
  echo ""
  echo "  🚨 FRAUD ALERT: Withdrawal amount exceeds limit of R$WITHDRAWAL_LIMIT."
  echo "  ❌ Transaction blocked for security reasons."
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  LOG_ENTRY="[$TIMESTAMP] ⚠️ FRAUD ALERT - BLOCKED | Attempted: R$AMOUNT | Limit: R$WITHDRAWAL_LIMIT | Balance: R$CURRENT_BALANCE"
  echo "$LOG_ENTRY" >> $LOG_FILE
  aws s3 cp $LOG_FILE $S3_BUCKET/logs/transaction.log --quiet
  exit 1
fi

# Fraud Check 2: Overdraft prevention
if [ $(echo "$AMOUNT > $CURRENT_BALANCE" | bc) -eq 1 ]; then
  echo ""
  echo "  ❌ Insufficient funds."
  echo "  Requested : R$AMOUNT"
  echo "  Available : R$CURRENT_BALANCE"
  exit 1
fi

# Fraud Check 3: Suspicious round-number large transaction warning
if [ $(echo "$AMOUNT >= 3000" | bc) -eq 1 ]; then
  echo ""
  echo "  ⚠️  WARNING: Large withdrawal detected (R$AMOUNT)."
  read -p "  Do you want to proceed? (yes/no): " CONFIRM
  if [ "$CONFIRM" != "yes" ]; then
    echo "  ❌ Transaction cancelled by user."
    exit 0
  fi
fi

# Calculate new balance
NEW_BALANCE=$(echo "$CURRENT_BALANCE - $AMOUNT" | bc)

# Save new balance to local file and upload to S3
echo "$NEW_BALANCE" > $ACCOUNT_FILE
aws s3 cp $ACCOUNT_FILE $S3_BUCKET/account.txt --quiet

# Log the transaction to S3
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_ENTRY="[$TIMESTAMP] WITHDRAWAL | Amount: R$AMOUNT | Before: R$CURRENT_BALANCE | After: R$NEW_BALANCE"
echo "$LOG_ENTRY" >> $LOG_FILE
aws s3 cp $LOG_FILE $S3_BUCKET/logs/transaction.log --quiet

echo ""
echo "  ✅ Withdrawal Successful!"
echo "  Amount Withdrawn : R$AMOUNT"
echo "  Previous Balance : R$CURRENT_BALANCE"
echo "  New Balance      : R$NEW_BALANCE"
echo "============================================"
