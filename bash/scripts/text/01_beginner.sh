#!/bin/bash
# Beginner Text Log Analyzer
# This script counts occurrences of different log levels in a text log file

# Default log file path or use command line argument if provided
LOG_FILE="${1:-../../examples/application.log}"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: Log file '$LOG_FILE' not found!"
  exit 1
fi

echo "Analyzing log file: $LOG_FILE"
echo

# Initialize counters for each log level
info_count=0
warn_count=0
error_count=0
debug_count=0
fatal_count=0

# Read the log file line by line
while IFS= read -r line; do
  # Check for each log level and update counters
  if [[ "$line" == *"[INFO]"* ]]; then
    ((info_count++))
  elif [[ "$line" == *"[WARN]"* ]]; then
    ((warn_count++))
  elif [[ "$line" == *"[ERROR]"* ]]; then
    ((error_count++))
  elif [[ "$line" == *"[DEBUG]"* ]]; then
    ((debug_count++))
  elif [[ "$line" == *"[FATAL]"* ]]; then
    ((fatal_count++))
  fi
done < "$LOG_FILE"

# Calculate total entries
total_count=$((info_count + warn_count + error_count + debug_count + fatal_count))

# Output the results
echo "Log Analysis Report"
echo "-------------------"
echo "INFO count  : $info_count"
echo "WARN count  : $warn_count"
echo "ERROR count : $error_count"
echo "DEBUG count : $debug_count"
echo "FATAL count : $fatal_count"
echo "-------------------"
echo "TOTAL ENTRIES: $total_count"