#!/bin/bash
# Intermediate Text Log Analyzer
# This script analyzes logs with more complex filtering and reporting

# Default log file path or use command line argument if provided
LOG_FILE="${1:-../../examples/application.log}"
OUTPUT_DIR="../../reports"
OUTPUT_FILE="$OUTPUT_DIR/text_log_analysis_report.txt"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "Error: Log file '$LOG_FILE' not found!"
  exit 1
fi

echo "Analyzing log file: $LOG_FILE"
echo

# Initialize counters for each log level
declare -A log_levels
log_levels=([INFO]=0 [WARN]=0 [ERROR]=0 [DEBUG]=0 [FATAL]=0)

# Initialize hourly counters
declare -A hourly_counts
for hour in {00..23}; do
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
    
    # Count user-related entries
    if [[ "$line" == *"user_id="* ]]; then
      ((user_action_count++))
      
      # Extract user ID if present
      if [[ "$line" =~ user_id=([0-9]+) ]]; then
        user_id="${BASH_REMATCH[1]}"
        user_ids["$user_id"]=1
      fi
    fi
  fi
done < "$LOG_FILE"

# Calculate total entries and error percentage
total_count=0
for level in "${!log_levels[@]}"; do
  ((total_count += log_levels[$level]))
done

error_percentage=$(( (log_levels[ERROR] + log_levels[FATAL]) * 100 / total_count ))

# Output the basic results
echo "Log Analysis Report"
echo "-------------------"
for level in INFO WARN ERROR DEBUG FATAL; do
  printf "%-6s count: %d\n" "$level" "${log_levels[$level]}"
done
echo "-------------------"
echo "TOTAL ENTRIES: $total_count"
echo "Error rate: $error_percentage%"
echo

# Find peak hours (hours with the most log entries)
echo "Activity by Hour:"
echo "----------------"
max_count=0
peak_hour=""

for hour in {0..23}; do
  count=${hourly_counts[$hour]}
  printf "Hour %02d: %d entries\n" "$hour" "$count"
  
  if (( count > max_count )); then
    max_count=$count
    peak_hour=$hour
  fi
done

echo
echo "Peak activity hour: $peak_hour:00 with $max_count entries"

# Save the comprehensive report to a file
{
  echo "TEXT LOG ANALYSIS REPORT"
  echo "========================"
  echo "Generated on: $(date)"
  echo "Log file: $LOG_FILE"
  echo "========================"
  echo
  echo "LOG LEVEL SUMMARY:"
  echo "------------------"
  for level in INFO WARN ERROR DEBUG FATAL; do
    printf "%-6s count: %d\n" "$level" "${log_levels[$level]}"
  done
  echo "------------------"
  echo "TOTAL ENTRIES: $total_count"
  echo "Error rate: $error_percentage%"
  echo
  echo "HOURLY ACTIVITY:"
  echo "---------------"
  for hour in {0..23}; do
    printf "Hour %02d: %d entries\n" "$hour" "${hourly_counts[$hour]}"
  done
  echo
  echo "Peak activity hour: $peak_hour:00 with $max_count entries"
  echo
  echo "USER ACTIVITY:"
  echo "-------------"
  echo "Total user-related log entries: $user_action_count"
  echo "Number of unique users: ${#user_ids[@]}"
} > "$OUTPUT_FILE"

echo
echo "Detailed report saved to $OUTPUT_FILE"