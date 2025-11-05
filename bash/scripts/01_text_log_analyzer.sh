#!/bin/bash
#########################################################
# Text Log Analyzer
#
# This script analyzes log files to count occurrences of 
# different log levels (INFO, WARN, ERROR, FATAL, DEBUG)
# and generates a report.
#
# Usage: ./01_text_log_analyzer.sh [log_file_path]
#########################################################

# Default log file path or use command line argument if provided
LOG_FILE="${1:-../examples/application.log}"
OUTPUT_DIR="../reports"
OUTPUT_FILE="$OUTPUT_DIR/text_log_analysis_report.txt"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Print script header
echo "==============================================" 
echo "            TEXT LOG FILE ANALYZER            "
echo "=============================================="
echo

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "❌ Error: Log file '$LOG_FILE' not found!"
  echo "Please provide a valid log file path or create the default one."
  exit 1
fi

echo "📊 Analyzing log file: $LOG_FILE"
echo

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

# Calculate total entries
total_count=$((info_count + warn_count + error_count + fatal_count + debug_count))

# Output the results
echo "📝 Log Analysis Report"
echo "=============================================="
echo "INFO count  : $info_count"
echo "WARN count  : $warn_count"
echo "ERROR count : $error_count"
echo "FATAL count : $fatal_count"
echo "DEBUG count : $debug_count"
echo "--------------------------------------------"
echo "TOTAL ENTRIES: $total_count"

# Save the report to a file
{
  echo "LOG ANALYSIS REPORT"
  echo "=============================================="
  echo "Generated on: $(date)"
  echo "Source file : $LOG_FILE"
  echo "=============================================="
  echo 
  echo "INFO count  : $info_count"
  echo "WARN count  : $warn_count"
  echo "ERROR count : $error_count"
  echo "FATAL count : $fatal_count"
  echo "DEBUG count : $debug_count"
  echo "--------------------------------------------"
  echo "TOTAL ENTRIES: $total_count"
} > "$OUTPUT_FILE"

echo
echo "✅ Report saved to $OUTPUT_FILE"