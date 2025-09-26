#!/bin/bash

# Set working directory to the mounted ledger folder
cd /ledger

# Get current year
CURRENT_YEAR=$(date '+%Y')

# Create timestamp for logging
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Log start (both to file and stdout for container logs)
echo "[$TIMESTAMP] Starting bean-price update for year $CURRENT_YEAR" | tee -a /var/log/bean-price.log

# Create prices directory if it doesn't exist
mkdir -p prices

# Define output filename with current year
OUTPUT_FILE="prices/price-${CURRENT_YEAR}.bean"

# Create temporary file for capturing errors
TEMP_ERR=$(mktemp)

# Run bean-price command - append to output file, capture errors separately
bean-price main.bean -i -c --update >> "$OUTPUT_FILE" 2>"$TEMP_ERR"

# Store exit code
EXIT_CODE=$?

# Check if there were any errors and log them
if [ -s "$TEMP_ERR" ]; then
    echo "[$TIMESTAMP] Errors encountered during bean-price execution:" | tee -a /var/log/bean-price.log
    while IFS= read -r line; do
        echo "[$TIMESTAMP] ERROR: $line" | tee -a /var/log/bean-price.log
    done < "$TEMP_ERR"
fi

# Clean up temporary error file
rm "$TEMP_ERR"

# Check if command was successful
if [ $EXIT_CODE -eq 0 ]; then
    echo "[$TIMESTAMP] bean-price update completed successfully" | tee -a /var/log/bean-price.log
    echo "[$TIMESTAMP] Output appended to /ledger/$OUTPUT_FILE" | tee -a /var/log/bean-price.log
else
    echo "[$TIMESTAMP] bean-price update failed with exit code $EXIT_CODE" | tee -a /var/log/bean-price.log
fi

# Log completion
echo "[$TIMESTAMP] bean-price script finished" | tee -a /var/log/bean-price.log