#!/bin/bash
# Intermediate JSON Log Analyzer
# This script performs more detailed analysis of JSON log files

# Default JSON log file path or use command line argument if provided
JSON_FILE="${1:-../../examples/activity_log.json}"
OUTPUT_DIR="../../reports"
REPORT_FILE="$OUTPUT_DIR/json_analysis_report.txt"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

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

# Get all unique users
mapfile -t users < <(jq -r '.[].userID' "$JSON_FILE" | sort -n | uniq)

# Initialize an associative array for user statistics
declare -A user_stats
declare -A user_success
declare -A user_failed
declare -A action_counts

# Process actions by user
for user in "${users[@]}"; do
  user_stats[$user]=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber))] | length' "$JSON_FILE")
  user_success[$user]=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber) and .status == "success")] | length' "$JSON_FILE")
  user_failed[$user]=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber) and .status == "failed")] | length' "$JSON_FILE")
done

# Count actions by type
mapfile -t action_types < <(jq -r '.[].action' "$JSON_FILE" | sort | uniq)
for action in "${action_types[@]}"; do
  action_counts[$action]=$(jq --arg action "$action" '[.[] | select(.action == $action)] | length' "$JSON_FILE")
done

# Output the overall results
echo "JSON Log Analysis Report"
echo "-----------------------"
echo "Total entries    : $total_count"
echo "Success count    : $success_count"
echo "Failed count     : $failed_count"
echo

# Output user statistics
echo "User Statistics:"
echo "---------------"
for user in "${users[@]}"; do
  echo "User $user:"
  echo "  Total actions: ${user_stats[$user]}"
  echo "  Successful  : ${user_success[$user]}"
  echo "  Failed      : ${user_failed[$user]}"
done
echo

# Output action statistics
echo "Action Statistics:"
echo "-----------------"
for action in "${action_types[@]}"; do
  echo "Action '$action': ${action_counts[$action]} occurrences"
done
echo

# List failed actions
echo "Failed Actions:"
echo "--------------"
jq -r '.[] | select(.status == "failed") | "[\(.timestamp)] User \(.userID) - \(.action)"' "$JSON_FILE"

# Save the report to a file
{
  echo "JSON LOG ANALYSIS REPORT"
  echo "========================"
  echo "Generated on: $(date)"
  echo "Log file: $JSON_FILE"
  echo "========================"
  echo
  echo "SUMMARY:"
  echo "--------"
  echo "Total entries    : $total_count"
  echo "Success count    : $success_count"
  echo "Failed count     : $failed_count"
  echo
  echo "USER STATISTICS:"
  echo "---------------"
  for user in "${users[@]}"; do
    echo "User $user:"
    echo "  Total actions: ${user_stats[$user]}"
    echo "  Successful  : ${user_success[$user]}"
    echo "  Failed      : ${user_failed[$user]}"
  done
  echo
  echo "ACTION STATISTICS:"
  echo "-----------------"
  for action in "${action_types[@]}"; do
    echo "Action '$action': ${action_counts[$action]} occurrences"
  done
  echo
  echo "FAILED ACTIONS:"
  echo "--------------"
  jq -r '.[] | select(.status == "failed") | "[\(.timestamp)] User \(.userID) - \(.action)"' "$JSON_FILE"
} > "$REPORT_FILE"

echo "Report saved to $REPORT_FILE"