#!/bin/bash
#########################################################
# JSON Log Analyzer
#
# This script analyzes JSON format logs to count 
# successful vs. failed actions, count actions per user,
# and provide details of failed actions.
#
# Usage: ./02_json_log_analyzer.sh [json_log_file_path]
#########################################################

# Default JSON log file path or use command line argument if provided
JSON_FILE="${1:-../examples/extended_activity_log.json}"
OUTPUT_DIR="../reports"
REPORT_FILE="$OUTPUT_DIR/json_log_analysis_report.txt"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Print script header
echo "==============================================" 
echo "            JSON LOG FILE ANALYZER            "
echo "=============================================="
echo

# Check if the JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
  echo "❌ Error: JSON file '$JSON_FILE' not found!"
  echo "Please provide a valid JSON file path or create the default one."
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "❌ Error: jq is not installed!"
  echo "Please install jq before running this script."
  echo "Installation: sudo apt-get install jq (Debian/Ubuntu)"
  echo "or: brew install jq (macOS)"
  exit 1
fi

echo "📊 Analyzing JSON log file: $JSON_FILE"
echo

# Initialize counters
success_count=0
failed_count=0
declare -A user_action_count

# Read the JSON file and count successes and failures
while IFS= read -r user_id; do
    user_action_count[$user_id]=$(jq "[.[] | select(.userID == $user_id)] | length" "$JSON_FILE")
done < <(jq '.[].userID | tostring' "$JSON_FILE" | sort | uniq)

success_count=$(jq '[.[] | select(.status == "success")] | length' "$JSON_FILE")
failed_count=$(jq '[.[] | select(.status == "failed")] | length' "$JSON_FILE")
total_count=$((success_count + failed_count))

# Output the overall results
echo "📝 JSON Log Analysis Report"
echo "=============================================="
echo "Total Actions    : $total_count"
echo "Success Actions  : $success_count"
echo "Failed Actions   : $failed_count"
echo

# Output user action counts
echo "📊 Actions by User:"
echo "=============================================="
for user_id in "${!user_action_count[@]}"; do
    echo "UserID $user_id: ${user_action_count[$user_id]} actions"
done

# Detailed report of failed attempts
echo
echo "⚠️ Failed Actions Details:"
echo "=============================================="
jq -r '.[] | select(.status == "failed") | "\(.timestamp) | UserID: \(.userID) | Action: \(.action)"' "$JSON_FILE"

# Save the report to a file
{
  echo "JSON LOG ANALYSIS REPORT"
  echo "=============================================="
  echo "Generated on: $(date)"
  echo "Source file : $JSON_FILE"
  echo "=============================================="
  echo 
  echo "Total Actions    : $total_count"
  echo "Success Actions  : $success_count"
  echo "Failed Actions   : $failed_count"
  echo
  echo "Actions by User:"
  echo "=============================================="
  for user_id in "${!user_action_count[@]}"; do
      echo "UserID $user_id: ${user_action_count[$user_id]} actions"
  done
  echo
  echo "Failed Actions Details:"
  echo "=============================================="
  jq -r '.[] | select(.status == "failed") | "\(.timestamp) | UserID: \(.userID) | Action: \(.action)"' "$JSON_FILE"
} > "$REPORT_FILE"

echo
echo "✅ Report saved to '$REPORT_FILE'."