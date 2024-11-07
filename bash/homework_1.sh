#!/bin/bash

# Path to the log file
LOG_FILE="application.log"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file not found!"
  exit 1
fi

# Initialize counters for each log level
info_count=0
warn_count=0
error_count=0
fatal_count=0
debug_count=0

# Read the log file line by line
while IFS= read -r line; do
  # Check for each log level and update counters
  if [[ "$line" == *"[INFO]"* ]]; then
    ((info_count++))
  elif [[ "$line" == *"[WARN]"* ]]; then
    ((warn_count++))
  elif [[ "$line" == *"[ERROR]"* ]]; then
    ((error_count++))
  elif [[ "$line" == *"[FATAL]"* ]]; then
    ((fatal_count++))
  elif [[ "$line" == *"[DEBUG]"* ]]; then
    ((debug_count++))
  fi
done < "$LOG_FILE"

# Output the results
echo "Log Analysis Report"
echo "--------------------"
echo "INFO count : $info_count"
echo "WARN count : $warn_count"
echo "ERROR count: $error_count"
echo "FATAL count: $fatal_count"
echo "DEBUG count: $debug_count"

# Optionally save the report to a file
OUTPUT_FILE="log_analysis_report.txt"
{
  echo "Log Analysis Report"
  echo "--------------------"
  echo "INFO count : $info_count"
  echo "WARN count : $warn_count"
  echo "ERROR count: $error_count"
  echo "FATAL count: $fatal_count"
  echo "DEBUG count: $debug_count"
} > "$OUTPUT_FILE"

echo "Report saved to $OUTPUT_FILE"

