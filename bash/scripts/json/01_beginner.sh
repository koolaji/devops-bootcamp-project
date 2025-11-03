#!/bin/bash
# Beginner JSON Log Analyzer
# This script performs basic analysis of JSON log files

# Default JSON log file path or use command line argument if provided
JSON_FILE="${1:-../../examples/activity_log.json}"

# Check if the JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
  echo "Error: JSON file '$JSON_FILE' not found!"
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is not installed!"
  echo "Please install jq before running this script."
  exit 1
fi

echo "Analyzing JSON log file: $JSON_FILE"
echo

# Count successful and failed actions
success_count=$(jq '[.[] | select(.status == "success")] | length' "$JSON_FILE")
failed_count=$(jq '[.[] | select(.status == "failed")] | length' "$JSON_FILE")
total_count=$(jq '. | length' "$JSON_FILE")

# Count unique users
unique_users=$(jq '[.[].userID] | unique | length' "$JSON_FILE")

# Output the results
echo "JSON Log Analysis Report"
echo "-----------------------"
echo "Total entries    : $total_count"
echo "Success count    : $success_count"
echo "Failed count     : $failed_count"
echo "Unique users     : $unique_users"