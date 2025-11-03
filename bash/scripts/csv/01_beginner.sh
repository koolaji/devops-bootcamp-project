#!/bin/bash
# Beginner CSV Log Analyzer
# This script performs basic analysis of CSV log files

# Default CSV log file path or use command line argument if provided
CSV_FILE="${1:-../../examples/activity_log.csv}"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: CSV file '$CSV_FILE' not found!"
  exit 1
fi

echo "Analyzing CSV log file: $CSV_FILE"
echo

# Initialize counters
total_count=0
success_count=0
failed_count=0

# Read the CSV file line by line, skipping the header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r timestamp user_id action status; do
  ((total_count++))
  
  if [[ "$status" == "success" ]]; then
    ((success_count++))
  elif [[ "$status" == "failed" ]]; then
    ((failed_count++))
  fi
done

# Output the results
echo "CSV Log Analysis Report"
echo "----------------------"
echo "Total entries: $total_count"
echo "Success count: $success_count"
echo "Failed count : $failed_count"