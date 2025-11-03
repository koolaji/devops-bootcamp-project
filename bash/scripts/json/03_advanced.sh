#!/bin/bash
# Advanced JSON Log Analyzer
# This script provides interactive analysis and visualization of JSON log data

# Default JSON log file path or use command line argument if provided
JSON_FILE="${1:-../../examples/extended_activity_log.json}"
OUTPUT_DIR="../../reports"
REPORT_PREFIX="advanced_json_analysis"

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

# Function to display a horizontal bar chart
display_bar_chart() {
  local title="$1"
  local -n data="$2"
  local max_label_length=0
  local max_value=0
  
  # Find maximum value and label length for formatting
  for label in "${!data[@]}"; do
    (( ${#label} > max_label_length )) && max_label_length=${#label}
    (( ${data[$label]} > max_value )) && max_value=${data[$label]}
  done
  
  echo "$title"
  echo "$(printf '%0.s-' $(seq 1 $((${#title} + 2))))"
  
  # Sort the data by value in descending order
  for label in $(for k in "${!data[@]}"; do echo "$k ${data[$k]}"; done | sort -k2,2nr | cut -d' ' -f1); do
    value=${data[$label]}
    # Calculate bar width proportional to the value
    bar_width=$(( value * 50 / max_value ))
    printf "%-*s |%s %d\n" "$max_label_length" "$label" "$(printf '%0.s#' $(seq 1 $bar_width))" "$value"
  done
  echo
}

# Function to analyze user behavior and detect anomalies
analyze_user_behavior() {
  local json_file="$1"
  
  echo "Analyzing user behavior patterns..."
  
  # Get typical action counts by user
  declare -A user_action_freq
  declare -A typical_actions
  
  # Calculate the typical number of actions per user
  mapfile -t users < <(jq -r '.[].userID' "$json_file" | sort -n | uniq)
  for user in "${users[@]}"; do
    user_action_freq[$user]=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber))] | length' "$json_file")
  done
  
  # Calculate the average number of actions across all users
  total_actions=0
  for user in "${users[@]}"; do
    ((total_actions += user_action_freq[$user]))
  done
  avg_actions=$((total_actions / ${#users[@]}))
  
  echo "User behavior analysis:"
  echo "-----------------------"
  echo "Average actions per user: $avg_actions"
  echo
  
  # Identify users with unusually high or low activity
  echo "Unusual activity patterns:"
  for user in "${users[@]}"; do
    actions=${user_action_freq[$user]}
    if (( actions > avg_actions * 2 )); then
      echo "  User $user: $actions actions ($(( actions * 100 / avg_actions ))% of average) - HIGH ACTIVITY"
    elif (( actions < avg_actions / 2 )) && (( actions > 0 )); then
      echo "  User $user: $actions actions ($(( actions * 100 / avg_actions ))% of average) - LOW ACTIVITY"
    fi
  done
  echo
  
  # Analyze action sequences
  echo "Action sequence patterns:"
  echo "-----------------------"
  
  # Get all actions in chronological order for each user
  for user in "${users[@]}"; do
    echo "User $user action flow:"
    jq -r --arg user "$user" '.[] | select(.userID == ($user | tonumber)) | "\(.timestamp) - \(.action) (\(.status))"' "$json_file" | sort
    echo
  done
}

# Function to perform time-based analysis
analyze_time_patterns() {
  local json_file="$1"
  
  echo "Analyzing activity patterns over time..."
  
  # Extract hour from timestamps and count activities
  declare -A hourly_activity
  
  while IFS= read -r timestamp; do
    if [[ "$timestamp" =~ T([0-9]{2}): ]]; then
      hour="${BASH_REMATCH[1]}"
      hour_key=${hour#0}  # Remove leading zero if present
      ((hourly_activity[$hour_key]++))
    fi
  done < <(jq -r '.[].timestamp' "$json_file")
  
  # Display hourly activity
  display_bar_chart "Activity by Hour" hourly_activity
  
  # Extract day of week from timestamps
  declare -A day_activity
  days=("Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat")
  
  while IFS= read -r timestamp; do
    if [[ "$timestamp" =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]; then
      year="${BASH_REMATCH[1]}"
      month="${BASH_REMATCH[2]}"
      day="${BASH_REMATCH[3]}"
      # Calculate day of week (0=Sunday, 6=Saturday)
      day_of_week=$(date -d "$year-$month-$day" +%w)
      day_name="${days[$day_of_week]}"
      ((day_activity["$day_name"]++))
    fi
  done < <(jq -r '.[].timestamp' "$json_file")
  
  # Display day of week activity
  if [[ ${#day_activity[@]} -gt 0 ]]; then
    display_bar_chart "Activity by Day of Week" day_activity
  fi
}

# Function to generate HTML report
generate_html_report() {
  local json_file="$1"
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local report_file="$OUTPUT_DIR/${REPORT_PREFIX}_${timestamp}.html"
  
  echo "Generating HTML report..."
  
  # Gather all data for the report
  local total_count=$(jq '. | length' "$json_file")
  local success_count=$(jq '[.[] | select(.status == "success")] | length' "$json_file")
  local failed_count=$(jq '[.[] | select(.status == "failed")] | length' "$json_file")
  local unique_users=$(jq '[.[].userID] | unique | length' "$json_file")
  
  # Get unique action types
  mapfile -t action_types < <(jq -r '.[].action' "$json_file" | sort | uniq)
  
  # Get unique users
  mapfile -t users < <(jq -r '.[].userID' "$json_file" | sort -n | uniq)
  
  # Generate the HTML
  {
    echo "<!DOCTYPE html>"
    echo "<html lang=\"en\">"
    echo "<head>"
    echo "  <meta charset=\"UTF-8\">"
    echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    echo "  <title>Advanced JSON Log Analysis Report</title>"
    echo "  <style>"
    echo "    body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }"
    echo "    h1 { color: #2c3e50; }"
    echo "    h2 { color: #3498db; margin-top: 30px; }"
    echo "    h3 { color: #2980b9; margin-top: 20px; }"
    echo "    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }"
    echo "    th, td { text-align: left; padding: 8px; border: 1px solid #ddd; }"
    echo "    th { background-color: #f2f2f2; }"
    echo "    tr:nth-child(even) { background-color: #f9f9f9; }"
    echo "    .success { color: #27ae60; }"
    echo "    .failed { color: #e74c3c; }"
    echo "    .chart-container { margin: 20px 0; max-width: 800px; }"
    echo "    .bar { height: 20px; margin: 5px 0; background-color: #3498db; }"
    echo "    .footer { margin-top: 30px; font-size: 0.8em; color: #7f8c8d; }"
    echo "  </style>"
    echo "</head>"
    echo "<body>"
    echo "  <h1>Advanced JSON Log Analysis Report</h1>"
    echo "  <p>Generated on: $(date)</p>"
    echo "  <p>Log file: $json_file</p>"
    
    echo "  <h2>Summary</h2>"
    echo "  <table>"
    echo "    <tr><th>Metric</th><th>Count</th></tr>"
    echo "    <tr><td>Total Entries</td><td>$total_count</td></tr>"
    echo "    <tr><td>Successful Actions</td><td><span class=\"success\">$success_count</span></td></tr>"
    echo "    <tr><td>Failed Actions</td><td><span class=\"failed\">$failed_count</span></td></tr>"
    echo "    <tr><td>Unique Users</td><td>$unique_users</td></tr>"
    echo "  </table>"
    
    echo "  <h2>Action Types</h2>"
    echo "  <table>"
    echo "    <tr><th>Action</th><th>Count</th><th>Success Rate</th></tr>"
    
    for action in "${action_types[@]}"; do
      action_total=$(jq --arg action "$action" '[.[] | select(.action == $action)] | length' "$json_file")
      action_success=$(jq --arg action "$action" '[.[] | select(.action == $action and .status == "success")] | length' "$json_file")
      success_rate=$((action_success * 100 / action_total))
      
      echo "    <tr>"
      echo "      <td>$action</td>"
      echo "      <td>$action_total</td>"
      echo "      <td>$success_rate%</td>"
      echo "    </tr>"
    done
    
    echo "  </table>"
    
    echo "  <h2>User Activity</h2>"
    echo "  <table>"
    echo "    <tr><th>User ID</th><th>Total Actions</th><th>Success Rate</th></tr>"
    
    for user in "${users[@]}"; do
      user_total=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber))] | length' "$json_file")
      user_success=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber) and .status == "success")] | length' "$json_file")
      success_rate=$((user_success * 100 / user_total))
      
      echo "    <tr>"
      echo "      <td>$user</td>"
      echo "      <td>$user_total</td>"
      echo "      <td>$success_rate%</td>"
      echo "    </tr>"
    done
    
    echo "  </table>"
    
    echo "  <h2>Failed Actions</h2>"
    echo "  <table>"
    echo "    <tr><th>Timestamp</th><th>User ID</th><th>Action</th></tr>"
    
    while IFS= read -r line; do
      IFS='|' read -r timestamp user_id action <<< "$line"
      echo "    <tr>"
      echo "      <td>$timestamp</td>"
      echo "      <td>$user_id</td>"
      echo "      <td>$action</td>"
      echo "    </tr>"
    done < <(jq -r '.[] | select(.status == "failed") | "\(.timestamp)|\(.userID)|\(.action)"' "$json_file")
    
    echo "  </table>"
    
    echo "  <div class=\"footer\">"
    echo "    <p>This report was generated automatically by the Advanced JSON Log Analyzer script.</p>"
    echo "  </div>"
    echo "</body>"
    echo "</html>"
  } > "$report_file"
  
  echo "HTML report saved to: $report_file"
}

# Interactive menu
display_menu() {
  clear
  echo "=== ADVANCED JSON LOG ANALYZER ==="
  echo "Log File: $JSON_FILE"
  echo
  echo "1. Basic Statistics"
  echo "2. User Activity Analysis"
  echo "3. Action Type Analysis"
  echo "4. Time-based Analysis"
  echo "5. Behavior Pattern Analysis"
  echo "6. Generate HTML Report"
  echo "7. Change Log File"
  echo "8. Exit"
  echo
  read -p "Select an option (1-8): " option
  
  case $option in
    1) show_basic_stats ;;
    2) show_user_activity ;;
    3) show_action_types ;;
    4) analyze_time_patterns "$JSON_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    5) analyze_user_behavior "$JSON_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    6) generate_html_report "$JSON_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    7) change_log_file ;;
    8) exit 0 ;;
    *) echo "Invalid option"; sleep 2; display_menu ;;
  esac
}

# Basic Statistics
show_basic_stats() {
  clear
  echo "=== BASIC STATISTICS ==="
  echo
  
  # Count successful and failed actions
  success_count=$(jq '[.[] | select(.status == "success")] | length' "$JSON_FILE")
  failed_count=$(jq '[.[] | select(.status == "failed")] | length' "$JSON_FILE")
  total_count=$(jq '. | length' "$JSON_FILE")
  
  # Count unique users and actions
  unique_users=$(jq '[.[].userID] | unique | length' "$JSON_FILE")
  unique_actions=$(jq '[.[].action] | unique | length' "$JSON_FILE")
  
  # Calculate success rate
  success_rate=$((success_count * 100 / total_count))
  
  echo "Total log entries: $total_count"
  echo "Successful actions: $success_count ($success_rate%)"
  echo "Failed actions: $failed_count ($((100 - success_rate))%)"
  echo "Unique users: $unique_users"
  echo "Unique action types: $unique_actions"
  
  read -p "Press Enter to continue..."
  display_menu
}

# User Activity Analysis
show_user_activity() {
  clear
  echo "=== USER ACTIVITY ANALYSIS ==="
  echo
  
  # Get unique users
  mapfile -t users < <(jq -r '.[].userID' "$JSON_FILE" | sort -n | uniq)
  
  # Initialize arrays for user statistics
  declare -A user_actions
  declare -A user_success
  declare -A user_failed
  
  # Process actions by user
  for user in "${users[@]}"; do
    user_actions[$user]=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber))] | length' "$JSON_FILE")
    user_success[$user]=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber) and .status == "success")] | length' "$JSON_FILE")
    user_failed[$user]=$(jq --arg user "$user" '[.[] | select(.userID == ($user | tonumber) and .status == "failed")] | length' "$JSON_FILE")
  done
  
  # Display user activity
  display_bar_chart "User Activity (Total Actions)" user_actions
  
  # Show detailed user statistics
  echo "Detailed User Statistics:"
  echo "-------------------------"
  for user in "${users[@]}"; do
    success_rate=$((user_success[$user] * 100 / user_actions[$user]))
    echo "User $user:"
    echo "  Total actions: ${user_actions[$user]}"
    echo "  Successful: ${user_success[$user]} ($success_rate%)"
    echo "  Failed: ${user_failed[$user]} ($((100 - success_rate))%)"
    echo
  done
  
  read -p "Press Enter to continue..."
  display_menu
}

# Action Type Analysis
show_action_types() {
  clear
  echo "=== ACTION TYPE ANALYSIS ==="
  echo
  
  # Get unique action types
  mapfile -t action_types < <(jq -r '.[].action' "$JSON_FILE" | sort | uniq)
  
  # Initialize array for action counts
  declare -A action_counts
  declare -A action_success
  declare -A action_failed
  
  # Count actions by type
  for action in "${action_types[@]}"; do
    action_counts[$action]=$(jq --arg action "$action" '[.[] | select(.action == $action)] | length' "$JSON_FILE")
    action_success[$action]=$(jq --arg action "$action" '[.[] | select(.action == $action and .status == "success")] | length' "$JSON_FILE")
    action_failed[$action]=$(jq --arg action "$action" '[.[] | select(.action == $action and .status == "failed")] | length' "$JSON_FILE")
  done
  
  # Display action counts
  display_bar_chart "Action Type Distribution" action_counts
  
  # Show detailed action statistics
  echo "Detailed Action Statistics:"
  echo "---------------------------"
  for action in "${action_types[@]}"; do
    success_rate=$((action_success[$action] * 100 / action_counts[$action]))
    echo "Action '$action':"
    echo "  Total occurrences: ${action_counts[$action]}"
    echo "  Successful: ${action_success[$action]} ($success_rate%)"
    echo "  Failed: ${action_failed[$action]} ($((100 - success_rate))%)"
    echo
  done
  
  read -p "Press Enter to continue..."
  display_menu
}

# Change log file
change_log_file() {
  clear
  echo "=== CHANGE LOG FILE ==="
  echo
  echo "Current log file: $JSON_FILE"
  echo
  read -p "Enter new log file path: " new_file
  
  if [[ -f "$new_file" ]]; then
    JSON_FILE="$new_file"
    echo "Log file changed successfully!"
  else
    echo "Error: File not found!"
  fi
  
  sleep 2
  display_menu
}

# Main script execution - start with the menu
clear
echo "=== ADVANCED JSON LOG ANALYZER ==="
echo "Version 1.0"
echo
echo "Initializing..."
sleep 1

if [[ ! -f "$JSON_FILE" ]]; then
  echo "Error: Default log file not found!"
  read -p "Enter log file path: " JSON_FILE
  
  if [[ ! -f "$JSON_FILE" ]]; then
    echo "Error: Invalid log file. Exiting."
    exit 1
  fi
fi

display_menu