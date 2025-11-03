#!/bin/bash
# Advanced CSV Log Analyzer
# This script provides interactive analysis and visualization of CSV log data

# Default CSV log file path or use command line argument if provided
CSV_FILE="${1:-../../examples/activity_log.csv}"
OUTPUT_DIR="../../reports"
REPORT_PREFIX="advanced_csv_analysis"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: CSV file '$CSV_FILE' not found!"
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

# Function to perform time-based analysis
analyze_time_patterns() {
  local csv_file="$1"
  
  echo "Analyzing activity patterns over time..."
  
  # Extract hour from timestamps and count activities
  declare -A hourly_activity
  
  awk -F',' '
  NR > 1 {
    if (match($1, /([0-9]{2}):[0-9]{2}:[0-9]{2}/, arr)) {
      hour = arr[1]
      hourly[hour]++
    }
  }
  END {
    for (hour in hourly) {
      print hour " " hourly[hour]
    }
  }
  ' "$csv_file" | while read -r hour count; do
    hourly_activity[$hour]=$count
  done
  
  # Display hourly activity
  display_bar_chart "Activity by Hour" hourly_activity
}

# Function to analyze user patterns
analyze_user_patterns() {
  local csv_file="$1"
  
  echo "Analyzing user activity patterns..."
  
  # Extract users and their actions
  declare -A user_actions
  declare -A user_success
  declare -A user_failed
  
  awk -F',' '
  NR > 1 {
    users[$2]++
    if ($4 == "success") {
      user_success[$2]++
    } else if ($4 == "failed") {
      user_failed[$2]++
    }
  }
  END {
    for (user in users) {
      print user " " users[user] " " user_success[user] " " user_failed[user]
    }
  }
  ' "$csv_file" | while read -r user total success failed; do
    user_actions[$user]=$total
    user_success[$user]=$success
    user_failed[$user]=$failed
  done
  
  # Display user activity
  display_bar_chart "Actions by User" user_actions
  
  # Calculate success rates
  echo "User Success Rates:"
  echo "------------------"
  for user in "${!user_actions[@]}"; do
    total=${user_actions[$user]}
    success=${user_success[$user]}
    success_rate=$((success * 100 / total))
    printf "User %s: %d%% success rate (%d of %d actions)\n" "$user" "$success_rate" "$success" "$total"
  done
  echo
}

# Function to analyze action patterns
analyze_action_patterns() {
  local csv_file="$1"
  
  echo "Analyzing action type patterns..."
  
  # Extract action types and counts
  declare -A action_counts
  declare -A action_success
  declare -A action_failed
  
  awk -F',' '
  NR > 1 {
    actions[$3]++
    if ($4 == "success") {
      action_success[$3]++
    } else if ($4 == "failed") {
      action_failed[$3]++
    }
  }
  END {
    for (action in actions) {
      print action " " actions[action] " " action_success[action] " " action_failed[action]
    }
  }
  ' "$csv_file" | while read -r action total success failed; do
    action_counts[$action]=$total
    action_success[$action]=$success
    action_failed[$action]=$failed
  done
  
  # Display action counts
  display_bar_chart "Action Type Distribution" action_counts
  
  # Calculate success rates
  echo "Action Success Rates:"
  echo "-------------------"
  for action in "${!action_counts[@]}"; do
    total=${action_counts[$action]}
    success=${action_success[$action]}
    success_rate=$((success * 100 / total))
    printf "Action '%s': %d%% success rate (%d of %d actions)\n" "$action" "$success_rate" "$success" "$total"
  done
  echo
}

# Function to generate HTML report
generate_html_report() {
  local csv_file="$1"
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local report_file="$OUTPUT_DIR/${REPORT_PREFIX}_${timestamp}.html"
  
  echo "Generating HTML report..."
  
  # Initialize data structures for report
  declare -A user_actions
  declare -A user_success
  declare -A user_failed
  declare -A action_counts
  declare -A action_success
  declare -A action_failed
  declare -A hourly_activity
  
  # Process the CSV file with awk
  awk -F',' '
  NR > 1 {
    # Extract hour
    if (match($1, /([0-9]{2}):[0-9]{2}:[0-9]{2}/, arr)) {
      hour = arr[1]
      hourly[hour]++
    }
    
    # Count by user
    users[$2]++
    if ($4 == "success") {
      user_success[$2]++
    } else if ($4 == "failed") {
      user_failed[$2]++
    }
    
    # Count by action
    actions[$3]++
    if ($4 == "success") {
      action_success[$3]++
    } else if ($4 == "failed") {
      action_failed[$3]++
    }
    
    # Total counts
    total++
    if ($4 == "success") {
      success++
    } else if ($4 == "failed") {
      failed++
    }
  }
  END {
    # Output summary
    print "SUMMARY"
    print total
    print success
    print failed
    
    # Output user data
    print "USERS"
    for (user in users) {
      print user "," users[user] "," user_success[user] "," user_failed[user]
    }
    
    # Output action data
    print "ACTIONS"
    for (action in actions) {
      print action "," actions[action] "," action_success[action] "," action_failed[action]
    }
    
    # Output hourly data
    print "HOURS"
    for (hour in hourly) {
      print hour "," hourly[hour]
    }
  }
  ' "$csv_file" > /tmp/csv_analysis.tmp
  
  # Parse the output file
  section=""
  total_count=0
  success_count=0
  failed_count=0
  
  while IFS= read -r line; do
    if [[ "$line" == "SUMMARY" ]]; then
      section="summary"
      continue
    elif [[ "$line" == "USERS" ]]; then
      section="users"
      continue
    elif [[ "$line" == "ACTIONS" ]]; then
      section="actions"
      continue
    elif [[ "$line" == "HOURS" ]]; then
      section="hours"
      continue
    fi
    
    case $section in
      "summary")
        if [[ -z "$total_count" ]]; then
          total_count="$line"
        elif [[ -z "$success_count" ]]; then
          success_count="$line"
        elif [[ -z "$failed_count" ]]; then
          failed_count="$line"
        fi
        ;;
      "users")
        IFS=',' read -r user total success failed <<< "$line"
        user_actions[$user]=$total
        user_success[$user]=$success
        user_failed[$user]=$failed
        ;;
      "actions")
        IFS=',' read -r action total success failed <<< "$line"
        action_counts[$action]=$total
        action_success[$action]=$success
        action_failed[$action]=$failed
        ;;
      "hours")
        IFS=',' read -r hour count <<< "$line"
        hourly_activity[$hour]=$count
        ;;
    esac
  done < /tmp/csv_analysis.tmp
  
  # Generate the HTML
  {
    echo "<!DOCTYPE html>"
    echo "<html lang=\"en\">"
    echo "<head>"
    echo "  <meta charset=\"UTF-8\">"
    echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    echo "  <title>Advanced CSV Log Analysis Report</title>"
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
    echo "  <h1>Advanced CSV Log Analysis Report</h1>"
    echo "  <p>Generated on: $(date)</p>"
    echo "  <p>Log file: $csv_file</p>"
    
    echo "  <h2>Summary</h2>"
    echo "  <table>"
    echo "    <tr><th>Metric</th><th>Count</th><th>Percentage</th></tr>"
    echo "    <tr><td>Total Entries</td><td>$total_count</td><td>100%</td></tr>"
    success_percentage=$((success_count * 100 / total_count))
    failed_percentage=$((failed_count * 100 / total_count))
    echo "    <tr><td>Successful Actions</td><td><span class=\"success\">$success_count</span></td><td>$success_percentage%</td></tr>"
    echo "    <tr><td>Failed Actions</td><td><span class=\"failed\">$failed_count</span></td><td>$failed_percentage%</td></tr>"
    echo "  </table>"
    
    echo "  <h2>User Activity</h2>"
    echo "  <table>"
    echo "    <tr><th>User ID</th><th>Total Actions</th><th>Success Rate</th></tr>"
    
    for user in "${!user_actions[@]}"; do
      total=${user_actions[$user]}
      success=${user_success[$user]}
      success_rate=$((success * 100 / total))
      
      echo "    <tr>"
      echo "      <td>$user</td>"
      echo "      <td>$total</td>"
      echo "      <td>$success_rate%</td>"
      echo "    </tr>"
    done
    
    echo "  </table>"
    
    echo "  <h2>Action Types</h2>"
    echo "  <table>"
    echo "    <tr><th>Action</th><th>Count</th><th>Success Rate</th></tr>"
    
    for action in "${!action_counts[@]}"; do
      total=${action_counts[$action]}
      success=${action_success[$action]}
      success_rate=$((success * 100 / total))
      
      echo "    <tr>"
      echo "      <td>$action</td>"
      echo "      <td>$total</td>"
      echo "      <td>$success_rate%</td>"
      echo "    </tr>"
    done
    
    echo "  </table>"
    
    echo "  <h2>Hourly Activity</h2>"
    echo "  <table>"
    echo "    <tr><th>Hour</th><th>Count</th></tr>"
    
    for hour in $(echo "${!hourly_activity[@]}" | tr ' ' '\n' | sort -n); do
      count=${hourly_activity[$hour]}
      
      echo "    <tr>"
      echo "      <td>${hour}:00</td>"
      echo "      <td>$count</td>"
      echo "    </tr>"
    done
    
    echo "  </table>"
    
    echo "  <div class=\"footer\">"
    echo "    <p>This report was generated automatically by the Advanced CSV Log Analyzer script.</p>"
    echo "  </div>"
    echo "</body>"
    echo "</html>"
  } > "$report_file"
  
  echo "HTML report saved to: $report_file"
  
  # Clean up temporary file
  rm /tmp/csv_analysis.tmp
}

# Interactive menu
display_menu() {
  clear
  echo "=== ADVANCED CSV LOG ANALYZER ==="
  echo "Log File: $CSV_FILE"
  echo
  echo "1. Basic Statistics"
  echo "2. User Analysis"
  echo "3. Action Type Analysis"
  echo "4. Time-based Analysis"
  echo "5. Filter and Search Logs"
  echo "6. Generate HTML Report"
  echo "7. Change Log File"
  echo "8. Exit"
  echo
  read -p "Select an option (1-8): " option
  
  case $option in
    1) show_basic_stats ;;
    2) analyze_user_patterns "$CSV_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    3) analyze_action_patterns "$CSV_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    4) analyze_time_patterns "$CSV_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    5) filter_logs ;;
    6) generate_html_report "$CSV_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    7) change_log_file ;;
    8) exit 0 ;;
    *) echo "Invalid option"; sleep 2; display_menu ;;
  esac
}

# Show basic statistics
show_basic_stats() {
  clear
  echo "=== BASIC STATISTICS ==="
  echo
  
  # Use awk to compute basic statistics
  awk -F',' '
    NR > 1 {
      total++
      if ($4 == "success") {
        success++
      } else if ($4 == "failed") {
        failed++
      }
    }
    END {
      print "Total entries: " total
      print "Success count: " success " (" success/total*100 "%)"
      print "Failed count : " failed " (" failed/total*100 "%)"
    }
  ' "$CSV_FILE"
  
  echo
  read -p "Press Enter to continue..."
  display_menu
}

# Filter logs based on user criteria
filter_logs() {
  clear
  echo "=== FILTER AND SEARCH LOGS ==="
  echo
  
  echo "Available filter options:"
  echo "1. By User ID"
  echo "2. By Action Type"
  echo "3. By Status (success/failed)"
  echo "4. By Timestamp (date/time range)"
  echo "5. Advanced Query"
  echo
  read -p "Select filter option (1-5): " filter_option
  
  case $filter_option in
    1)
      # List available users
      echo "Available users:"
      awk -F',' 'NR > 1 { users[$2]=1 } END { for (user in users) print "  " user }' "$CSV_FILE"
      read -p "Enter User ID to filter: " user_id
      
      echo
      echo "Log entries for User $user_id:"
      echo "-----------------------------"
      awk -F',' -v user="$user_id" '
        NR == 1 { print "Timestamp | Action | Status" }
        NR > 1 && $2 == user { print $1 " | " $3 " | " $4 }
      ' "$CSV_FILE"
      ;;
    2)
      # List available actions
      echo "Available actions:"
      awk -F',' 'NR > 1 { actions[$3]=1 } END { for (action in actions) print "  " action }' "$CSV_FILE"
      read -p "Enter Action Type to filter: " action_type
      
      echo
      echo "Log entries for Action '$action_type':"
      echo "------------------------------------"
      awk -F',' -v action="$action_type" '
        NR == 1 { print "Timestamp | User | Status" }
        NR > 1 && $3 == action { print $1 " | User " $2 " | " $4 }
      ' "$CSV_FILE"
      ;;
    3)
      read -p "Enter Status to filter (success/failed): " status_filter
      
      echo
      echo "Log entries with Status '$status_filter':"
      echo "--------------------------------------"
      awk -F',' -v status="$status_filter" '
        NR == 1 { print "Timestamp | User | Action" }
        NR > 1 && $4 == status { print $1 " | User " $2 " | " $3 }
      ' "$CSV_FILE"
      ;;
    4)
      read -p "Enter start time (YYYY-MM-DD HH:MM:SS format or leave empty): " start_time
      read -p "Enter end time (YYYY-MM-DD HH:MM:SS format or leave empty): " end_time
      
      if [[ -z "$start_time" && -z "$end_time" ]]; then
        echo "No time range specified!"
      else
        echo
        echo "Log entries in specified time range:"
        echo "----------------------------------"
        awk -F',' -v start="$start_time" -v end="$end_time" '
          NR == 1 { print "Timestamp | User | Action | Status" }
          NR > 1 { 
            if ((start == "" || $1 >= start) && (end == "" || $1 <= end)) {
              print $1 " | User " $2 " | " $3 " | " $4
            }
          }
        ' "$CSV_FILE"
      fi
      ;;
    5)
      echo "Advanced Query allows you to combine multiple filters."
      read -p "Enter User ID (or leave empty): " query_user
      read -p "Enter Action Type (or leave empty): " query_action
      read -p "Enter Status (or leave empty): " query_status
      
      echo
      echo "Query Results:"
      echo "-------------"
      awk -F',' -v user="$query_user" -v action="$query_action" -v status="$query_status" '
        NR == 1 { print "Timestamp | User | Action | Status" }
        NR > 1 {
          if ((user == "" || $2 == user) && 
              (action == "" || $3 == action) && 
              (status == "" || $4 == status)) {
            print $1 " | User " $2 " | " $3 " | " $4
          }
        }
      ' "$CSV_FILE"
      ;;
    *)
      echo "Invalid option!"
      ;;
  esac
  
  echo
  read -p "Press Enter to continue..."
  display_menu
}

# Change log file
change_log_file() {
  clear
  echo "=== CHANGE LOG FILE ==="
  echo
  echo "Current log file: $CSV_FILE"
  echo
  read -p "Enter new log file path: " new_file
  
  if [[ -f "$new_file" ]]; then
    CSV_FILE="$new_file"
    echo "Log file changed successfully!"
  else
    echo "Error: File not found!"
  fi
  
  sleep 2
  display_menu
}

# Main script execution - start with the menu
clear
echo "=== ADVANCED CSV LOG ANALYZER ==="
echo "Version 1.0"
echo
echo "Initializing..."
sleep 1

if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: Default log file not found!"
  read -p "Enter log file path: " CSV_FILE
  
  if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: Invalid log file. Exiting."
    exit 1
  fi
fi

display_menu