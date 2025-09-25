#!/bin/bash

# Set working directory to the mounted ledger folder
cd /ledger

# Get current year
CURRENT_YEAR=$(date '+%Y')

# Create timestamp for logging
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Log start
echo "[$TIMESTAMP] Starting bean-price update for year $CURRENT_YEAR" >> /var/log/bean-price.log

# Create prices directory if it doesn't exist
mkdir -p prices

# Define output filename with current year
OUTPUT_FILE="prices/price-${CURRENT_YEAR}.bean"

# Run bean-price command and save output to the year-specific price file
bean-price -v main.bean -i -c --update > "$OUTPUT_FILE" 2>&1

# Check if command was successful
if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] bean-price update completed successfully" >> /var/log/bean-price.log
    echo "[$TIMESTAMP] Output saved to /ledger/$OUTPUT_FILE" >> /var/log/bean-price.log
else
    echo "[$TIMESTAMP] bean-price update failed with exit code $?" >> /var/log/bean-price.log
fi

# Log completion
echo "[$TIMESTAMP] bean-price script finished" >> /var/log/bean-price.log