#!/bin/bash

# ============================================
# AWS Fintech ATM Simulation System
# Author: Blessing Rakoma
# Deposit Script - deposit.sh
# ============================================

S3_BUCKET="s3://atm-simulation-bucket"
ACCOUNT_FILE="/tmp/account.txt"
LOG_FILE="/tmp/transaction.log"

# Load current balance from S3
aws s3 cp $S3_BUCKET/account.txt $ACCOUNT_FILE --quiet
CURRENT_BALANCE=$(cat $ACCOUNT_FILE)

echo ""
echo "============================================"
echo "   💳 Deposit"
echo "============================================"
read -p "  Enter deposit amount (R): " AMOUNT

# Validate: amount must be a positive number
if ! [[ "$AMOUNT" =~ ^[0-9]+(\.[0-9]+)?$ ]] || [ $(echo "$AMOUNT <= 0" | bc) -eq 1 ]; then
  echo "  ❌ Invalid amount. Please enter a positive number."
  exit 1
fi

# Validate: minimum deposit is R10
if [ $(echo "$AMOUNT < 10" | bc) -eq 1 ]; then
  echo "  ❌ Minimum deposit amount is R10."
  exit 1
fi

# Calculate new balance
NEW_BALANCE=$(echo "$CURRENT_BALANCE + $AMOUNT" | bc)

# Save new balance to local file and upload to S3
echo "$NEW_BALANCE" > $ACCOUNT_FILE
aws s3 cp $ACCOUNT_FILE $S3_BUCKET/account.txt --quiet

# Log the transaction to S3
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_ENTRY="[$TIMESTAMP] DEPOSIT | Amount: R$AMOUNT | Before: R$CURRENT_BALANCE | After: R$NEW_BALANCE"
echo "$LOG_ENTRY" >> $LOG_FILE
aws s3 cp $LOG_FILE $S3_BUCKET/logs/transaction.log --quiet

echo ""
echo "  ✅ Deposit Successful!"
echo "  Amount Deposited : R$AMOUNT"
echo "  Previous Balance : R$CURRENT_BALANCE"
echo "  New Balance      : R$NEW_BALANCE"
echo "============================================"
