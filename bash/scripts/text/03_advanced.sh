#!/bin/bash
# Advanced Text Log Analyzer
# This script provides interactive analysis of log files with pattern detection
# and visualization capabilities

# Default log file path or use command line argument if provided
LOG_FILE="${1:-../../examples/application.log}"
OUTPUT_DIR="../../reports"
REPORT_PREFIX="advanced_text_analysis"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: Log file '$LOG_FILE' not found!"
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

# Function to analyze log patterns and detect anomalies
analyze_patterns() {
  local log_file="$1"
  local timespan=60  # seconds for grouping events
  local threshold=3  # threshold for anomaly detection
  
  echo "Analyzing patterns and detecting anomalies..."
  
  # Group log entries by minute
  declare -A minute_counts
  
  while IFS= read -r line; do
    if [[ "$line" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}):[0-9]{2} ]]; then
      minute="${BASH_REMATCH[1]}"
      ((minute_counts["$minute"]++))
    fi
  done < "$log_file"
  
  # Detect anomalies (minutes with unusually high activity)
  echo "Potential anomalies detected:"
  echo "--------------------------"
  
  # Calculate average entries per minute
  total_entries=0
  for minute in "${!minute_counts[@]}"; do
    ((total_entries += minute_counts["$minute"]))
  done
  avg_per_minute=$(( total_entries / ${#minute_counts[@]} ))
  
  # Identify minutes with activity above threshold
  anomaly_found=false
  for minute in "${!minute_counts[@]}"; do
    if (( minute_counts["$minute"] > avg_per_minute * threshold )); then
      echo "Time $minute: ${minute_counts["$minute"]} entries ($(( minute_counts["$minute"] / avg_per_minute ))x normal rate)"
      anomaly_found=true
    fi
  done
  
  if ! $anomaly_found; then
    echo "No significant anomalies detected"
  fi
  echo
}

# Function to extract and analyze error sequences
analyze_error_sequences() {
  local log_file="$1"
  
  echo "Analyzing error sequences and correlations..."
  
  # Track sequences of errors and the messages that precede them
  declare -A error_context
  declare -a last_5_lines=()
  
  while IFS= read -r line; do
    # Keep track of the last 5 lines
    last_5_lines=("${last_5_lines[@]:1}" "$line")
    
    # Check if this is an error or fatal line
    if [[ "$line" =~ \[(ERROR|FATAL)\] ]]; then
      # Extract the error message
      if [[ "$line" =~ \[(ERROR|FATAL)\]\ (.*) ]]; then
        error_msg="${BASH_REMATCH[2]}"
        # Look at previous lines for context
        for prev_line in "${last_5_lines[@]:0:4}"; do
          if [[ "$prev_line" =~ \[(INFO|WARN|DEBUG)\]\ (.*) ]]; then
            context="${BASH_REMATCH[2]}"
            error_context["$context -> $error_msg"]=$((${error_context["$context -> $error_msg"]} + 1))
          fi
        done
      fi
    fi
  done < "$log_file"
  
  echo "Common error patterns detected:"
  echo "-----------------------------"
  
  # Display top error patterns
  count=0
  for pattern in $(for k in "${!error_context[@]}"; do echo "${error_context[$k]} $k"; done | sort -rn | head -5 | cut -d' ' -f2-); do
    echo "Pattern: $pattern (${error_context["$pattern"]} occurrences)"
    ((count++))
  done
  
  if [[ $count -eq 0 ]]; then
    echo "No significant error patterns detected"
  fi
  echo
}

# Interactive menu
display_menu() {
  clear
  echo "=== ADVANCED LOG ANALYZER ==="
  echo "Log File: $LOG_FILE"
  echo
  echo "1. Basic Log Level Analysis"
  echo "2. Temporal Analysis (Activity by Hour)"
  echo "3. User Activity Analysis"
  echo "4. Pattern and Anomaly Detection"
  echo "5. Error Sequence Analysis"
  echo "6. Generate Comprehensive Report"
  echo "7. Change Log File"
  echo "8. Exit"
  echo
  read -p "Select an option (1-8): " option
  
  case $option in
    1) analyze_log_levels ;;
    2) analyze_by_time ;;
    3) analyze_user_activity ;;
    4) analyze_patterns "$LOG_FILE" ;;
    5) analyze_error_sequences "$LOG_FILE" ;;
    6) generate_comprehensive_report ;;
    7) change_log_file ;;
    8) exit 0 ;;
    *) echo "Invalid option"; sleep 2; display_menu ;;
  esac
}

# Basic Log Level Analysis
analyze_log_levels() {
  clear
  echo "=== LOG LEVEL ANALYSIS ==="
  echo
  
  # Initialize counters for each log level
  declare -A log_levels
  log_levels=([INFO]=0 [WARN]=0 [ERROR]=0 [DEBUG]=0 [FATAL]=0)
  
  # Read the log file line by line
  while IFS= read -r line; do
    # Extract log level
    if [[ "$line" =~ \[([A-Z]+)\] ]]; then
      log_level="${BASH_REMATCH[1]}"
      ((log_levels[$log_level]++))
    fi
  done < "$LOG_FILE"
  
  # Display results as a bar chart
  display_bar_chart "LOG LEVELS DISTRIBUTION" log_levels
  
  read -p "Press Enter to continue..."
  display_menu
}

# Temporal Analysis
analyze_by_time() {
  clear
  echo "=== TEMPORAL ANALYSIS ==="
  echo
  
  # Initialize hourly counters
  declare -A hourly_counts
  for hour in {0..23}; do
    hourly_counts[$hour]=0
  done
  
  # Read the log file line by line
  while IFS= read -r line; do
    # Extract the hour
    if [[ "$line" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ ([0-9]{2}): ]]; then
      hour="${BASH_REMATCH[1]}"
      hour_key=${hour#0}  # Remove leading zero if present
      ((hourly_counts[$hour_key]++))
    fi
  done < "$LOG_FILE"
  
  # Display results as a bar chart
  display_bar_chart "ACTIVITY BY HOUR" hourly_counts
  
  read -p "Press Enter to continue..."
  display_menu
}

# User Activity Analysis
analyze_user_activity() {
  clear
  echo "=== USER ACTIVITY ANALYSIS ==="
  echo
  
  declare -A user_actions
  total_user_actions=0
  
  # Read the log file line by line
  while IFS= read -r line; do
    # Extract user ID if present
    if [[ "$line" =~ user_id=([0-9]+) ]]; then
      user_id="${BASH_REMATCH[1]}"
      ((user_actions["$user_id"]++))
      ((total_user_actions++))
    fi
  done < "$LOG_FILE"
  
  echo "Total user-related log entries: $total_user_actions"
  echo "Number of unique users: ${#user_actions[@]}"
  echo
  
  # Display results as a bar chart
  display_bar_chart "ACTIVITY BY USER" user_actions
  
  read -p "Press Enter to continue..."
  display_menu
}

# Generate Comprehensive Report
generate_comprehensive_report() {
  clear
  echo "=== GENERATING COMPREHENSIVE REPORT ==="
  echo
  
  timestamp=$(date +"%Y%m%d_%H%M%S")
  REPORT_FILE="$OUTPUT_DIR/${REPORT_PREFIX}_${timestamp}.html"
  
  echo "Analyzing log data..."
  
  # Initialize data structures for analysis
  declare -A log_levels hourly_counts user_actions
  log_levels=([INFO]=0 [WARN]=0 [ERROR]=0 [DEBUG]=0 [FATAL]=0)
  for hour in {0..23}; do
    hourly_counts[$hour]=0
  done
  
  # Read the log file line by line
  while IFS= read -r line; do
    # Extract the timestamp, hour, and log level
    if [[ "$line" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}):([0-9]{2}:[0-9]{2})\ \[([A-Z]+)\] ]]; then
      timestamp="${BASH_REMATCH[1]}"
      hour="${timestamp##* }"
      log_level="${BASH_REMATCH[3]}"
      
      # Update log level counter
      ((log_levels[$log_level]++))
      
      # Update hourly counter (removing leading zero if present)
      hour_key=${hour#0}
      ((hourly_counts[$hour_key]++))
      
      # Extract user ID if present
      if [[ "$line" =~ user_id=([0-9]+) ]]; then
        user_id="${BASH_REMATCH[1]}"
        ((user_actions["$user_id"]++))
      fi
    fi
  done < "$LOG_FILE"
  
  # Calculate totals
  total_entries=0
  for level in "${!log_levels[@]}"; do
    ((total_entries += log_levels[$level]))
  done
  
  # Find peak hour
  max_count=0
  peak_hour=""
  for hour in {0..23}; do
    if (( hourly_counts[$hour] > max_count )); then
      max_count=${hourly_counts[$hour]}
      peak_hour=$hour
    fi
  done
  
  # Generate HTML report
  {
    echo "<!DOCTYPE html>"
    echo "<html lang=\"en\">"
    echo "<head>"
    echo "  <meta charset=\"UTF-8\">"
    echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    echo "  <title>Advanced Log Analysis Report</title>"
    echo "  <style>"
    echo "    body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }"
    echo "    h1 { color: #2c3e50; }"
    echo "    h2 { color: #3498db; margin-top: 30px; }"
    echo "    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }"
    echo "    th, td { text-align: left; padding: 8px; border: 1px solid #ddd; }"
    echo "    th { background-color: #f2f2f2; }"
    echo "    tr:nth-child(even) { background-color: #f9f9f9; }"
    echo "    .chart-container { margin: 20px 0; max-width: 800px; }"
    echo "    .bar { background-color: #3498db; height: 20px; margin: 5px 0; }"
    echo "    .label { display: inline-block; width: 100px; }"
    echo "    .error { color: #e74c3c; }"
    echo "    .warning { color: #f39c12; }"
    echo "    .info { color: #2980b9; }"
    echo "    .footer { margin-top: 30px; font-size: 0.8em; color: #7f8c8d; }"
    echo "  </style>"
    echo "</head>"
    echo "<body>"
    echo "  <h1>Advanced Log Analysis Report</h1>"
    echo "  <p>Generated on: $(date)</p>"
    echo "  <p>Log file: $LOG_FILE</p>"
    echo "  <p>Total log entries: $total_entries</p>"
    echo ""
    echo "  <h2>Log Level Distribution</h2>"
    echo "  <table>"
    echo "    <tr><th>Log Level</th><th>Count</th><th>Percentage</th></tr>"
    for level in INFO WARN ERROR DEBUG FATAL; do
      count=${log_levels[$level]}
      percentage=$(( count * 100 / total_entries ))
      echo "    <tr><td>${level}</td><td>${count}</td><td>${percentage}%</td></tr>"
    done
    echo "  </table>"
    echo ""
    echo "  <div class=\"chart-container\">"
    for level in INFO WARN ERROR DEBUG FATAL; do
      count=${log_levels[$level]}
      width=$(( count * 100 / total_entries ))
      echo "    <div class=\"label\">${level}:</div>"
      echo "    <div class=\"bar\" style=\"width: ${width}%\"></div>"
    done
    echo "  </div>"
    echo ""
    echo "  <h2>Temporal Analysis</h2>"
    echo "  <p>Peak activity hour: ${peak_hour}:00 with ${max_count} entries</p>"
    echo "  <table>"
    echo "    <tr><th>Hour</th><th>Count</th></tr>"
    for hour in {0..23}; do
      count=${hourly_counts[$hour]}
      echo "    <tr><td>${hour}:00</td><td>${count}</td></tr>"
    done
    echo "  </table>"
    echo ""
    echo "  <h2>User Activity</h2>"
    echo "  <p>Number of unique users: ${#user_actions[@]}</p>"
    echo "  <table>"
    echo "    <tr><th>User ID</th><th>Actions</th></tr>"
    for user_id in $(for k in "${!user_actions[@]}"; do echo "$k ${user_actions[$k]}"; done | sort -k2,2nr | cut -d' ' -f1 | head -10); do
      count=${user_actions[$user_id]}
      echo "    <tr><td>${user_id}</td><td>${count}</td></tr>"
    done
    echo "  </table>"
    echo ""
    echo "  <div class=\"footer\">"
    echo "    <p>This report was generated automatically by the Advanced Text Log Analyzer script.</p>"
    echo "  </div>"
    echo "</body>"
    echo "</html>"
  } > "$REPORT_FILE"
  
  echo "Comprehensive HTML report generated: $REPORT_FILE"
  echo
  read -p "Press Enter to continue..."
  display_menu
}

# Change log file
change_log_file() {
  clear
  echo "=== CHANGE LOG FILE ==="
  echo
  echo "Current log file: $LOG_FILE"
  echo
  read -p "Enter new log file path: " new_file
  
  if [[ -f "$new_file" ]]; then
    LOG_FILE="$new_file"
    echo "Log file changed successfully!"
  else
    echo "Error: File not found!"
  fi
  
  sleep 2
  display_menu
}

# Main script execution - start with the menu
clear
echo "=== ADVANCED TEXT LOG ANALYZER ==="
echo "Version 1.0"
echo
echo "Initializing..."
sleep 1

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: Default log file not found!"
  read -p "Enter log file path: " LOG_FILE
  
  if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Invalid log file. Exiting."
    exit 1
  fi
fi

display_menu