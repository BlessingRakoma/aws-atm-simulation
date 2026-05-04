#!/bin/bash

# ============================================
# AWS Fintech ATM Simulation System
# Author: Blessing Rakoma
# Transaction Statement Script - statement.sh
# ============================================

S3_BUCKET="s3://atm-simulation-bucket"
ACCOUNT_FILE="/tmp/account.txt"
LOG_FILE="/tmp/transaction.log"

echo ""
echo "============================================"
echo "   📋 Transaction Statement"
echo "   Account: Blessing Rakoma"
echo "   Generated: $(date "+%Y-%m-%d %H:%M:%S")"
echo "============================================"

# Download latest log from S3
aws s3 cp $S3_BUCKET/logs/transaction.log $LOG_FILE --quiet 2>/dev/null

# Check if log file exists and has content
if [ ! -f "$LOG_FILE" ] || [ ! -s "$LOG_FILE" ]; then
  echo "  No transactions found."
else
  echo ""
  cat $LOG_FILE
  echo ""
  echo "  Total transactions: $(wc -l < $LOG_FILE)"
fi

# Show current balance
aws s3 cp $S3_BUCKET/account.txt $ACCOUNT_FILE --quiet
CURRENT_BALANCE=$(cat $ACCOUNT_FILE)

echo ""
echo "============================================"
echo "  💰 Current Balance: R$CURRENT_BALANCE"
echo "============================================"
