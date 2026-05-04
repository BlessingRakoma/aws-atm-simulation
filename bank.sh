#!/bin/bash

# ============================================
# AWS Fintech ATM Simulation System
# Author: Blessing Rakoma
# Main Menu Script - bank.sh
# ============================================

S3_BUCKET="s3://atm-simulation-bucket"
ACCOUNT_FILE="/tmp/account.txt"
LOG_FILE="/tmp/transaction.log"

# Load account data from S3
aws s3 cp $S3_BUCKET/account.txt $ACCOUNT_FILE --quiet

# If no account file exists, create one with zero balance
if [ ! -f "$ACCOUNT_FILE" ]; then
  echo "0" > $ACCOUNT_FILE
  aws s3 cp $ACCOUNT_FILE $S3_BUCKET/account.txt --quiet
fi

# ---- Main Menu ----
while true; do
  echo ""
  echo "============================================"
  echo "   🏧 AWS Fintech ATM Simulation System"
  echo "   Author: Blessing Rakoma"
  echo "============================================"
  echo "  1. Deposit"
  echo "  2. Withdraw"
  echo "  3. Check Balance"
  echo "  4. View Statement"
  echo "  5. Exit"
  echo "============================================"
  read -p "Select an option (1-5): " OPTION

  case $OPTION in
    1) bash deposit.sh ;;
    2) bash withdraw.sh ;;
    3)
      BALANCE=$(cat $ACCOUNT_FILE)
      echo ""
      echo "  💰 Current Balance: R$BALANCE"
      ;;
    4) bash statement.sh ;;
    5)
      echo ""
      echo "  Thank you for using AWS ATM. Goodbye!"
      echo ""
      exit 0
      ;;
    *)
      echo "  ❌ Invalid option. Please select 1-5."
      ;;
  esac
done
