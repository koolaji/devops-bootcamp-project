#!/bin/bash

# Path to the JSON log file
JSON_FILE="extended_activity_log.json"

# Check if the JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
  echo "JSON file not found! Please ensure that '$JSON_FILE' exists."
  exit 1
fi

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

# Output the overall results
echo "JSON Log Analysis Report"
echo "------------------------"
echo "Total Success Actions: $success_count"
echo "Total Failed Actions  : $failed_count"

# Output user action counts
echo "Actions by User:"
for user_id in "${!user_action_count[@]}"; do
    echo "UserID $user_id: ${user_action_count[$user_id]} actions"
done

# Detailed report of failed attempts
echo
echo "Failed Actions Details:"
echo "-----------------------"
jq -r '.[] | select(.status == "failed") | "\(.timestamp) | UserID: \(.userID) | Action: \(.action)"' "$JSON_FILE"

# Save the report to a file
REPORT_FILE="json_log_analysis_report.txt"
{
  echo "JSON Log Analysis Report"
  echo "------------------------"
  echo "Total Success Actions: $success_count"
  echo "Total Failed Actions  : $failed_count"
  echo "Actions by User:"
  for user_id in "${!user_action_count[@]}"; do
      echo "UserID $user_id: ${user_action_count[$user_id]} actions"
  done
  echo
  echo "Failed Actions Details:"
  echo "-----------------------"
  jq -r '.[] | select(.status == "failed") | "\(.timestamp) | UserID: \(.userID) | Action: \(.action)"' "$JSON_FILE"
} > "$REPORT_FILE"

echo "Report saved to '$REPORT_FILE'."

