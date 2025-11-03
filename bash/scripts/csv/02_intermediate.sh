#!/bin/bash
# Intermediate CSV Log Analyzer
# This script performs more detailed analysis of CSV log files

# Default CSV log file path or use command line argument if provided
CSV_FILE="${1:-../../examples/activity_log.csv}"
OUTPUT_DIR="../../reports"
REPORT_FILE="$OUTPUT_DIR/csv_analysis_report.txt"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
  echo "Error: CSV file '$CSV_FILE' not found!"
  exit 1
fi

echo "Analyzing CSV log file: $CSV_FILE"
echo

# Initialize arrays for statistics
declare -A user_counts
declare -A action_counts
declare -A user_success
declare -A user_failed

# Read the CSV file and gather statistics
awk -F',' '
  NR > 1 {
    users[$2]++
    actions[$3]++
    total++
    if ($4 == "success") {
      success++
      user_success[$2]++
    } else if ($4 == "failed") {
      failed++
      user_failed[$2]++
    }
  }
  END {
    print "Total entries: " total
    print "Success count: " success
    print "Failed count : " failed
    print ""
    print "User statistics:"
    for (user in users) {
      print "  User " user ": " users[user] " actions (" user_success[user] " success, " user_failed[user] " failed)"
    }
    print ""
    print "Action statistics:"
    for (action in actions) {
      print "  Action " action ": " actions[action] " occurrences"
    }
  }
' "$CSV_FILE"

# Prompt the user for filtering options
echo
echo "Filter options:"
echo "1. Show entries for a specific user"
echo "2. Show entries for a specific action"
echo "3. Show only failed entries"
echo "4. Show only successful entries"
echo "5. No filtering (show all)"
read -p "Select an option (1-5): " filter_option

# Apply the selected filter
case $filter_option in
  1)
    read -p "Enter user ID: " user_id
    echo
    echo "Entries for user $user_id:"
    awk -F',' -v user="$user_id" 'NR > 1 && $2 == user { print $1 " | " $3 " | " $4 }' "$CSV_FILE"
    ;;
  2)
    read -p "Enter action name: " action_name
    echo
    echo "Entries for action '$action_name':"
    awk -F',' -v action="$action_name" 'NR > 1 && $3 == action { print $1 " | User " $2 " | " $4 }' "$CSV_FILE"
    ;;
  3)
    echo
    echo "Failed entries:"
    awk -F',' 'NR > 1 && $4 == "failed" { print $1 " | User " $2 " | " $3 }' "$CSV_FILE"
    ;;
  4)
    echo
    echo "Successful entries:"
    awk -F',' 'NR > 1 && $4 == "success" { print $1 " | User " $2 " | " $3 }' "$CSV_FILE"
    ;;
  5)
    echo
    echo "All entries:"
    awk -F',' 'NR > 1 { print $1 " | User " $2 " | " $3 " | " $4 }' "$CSV_FILE"
    ;;
  *)
    echo "Invalid option. No filtering applied."
    ;;
esac

# Generate the report file with all statistics
{
  echo "CSV LOG ANALYSIS REPORT"
  echo "======================="
  echo "Generated on: $(date)"
  echo "Log file: $CSV_FILE"
  echo "======================="
  echo
  
  awk -F',' '
    NR > 1 {
      users[$2]++
      actions[$3]++
      total++
      if ($4 == "success") {
        success++
        user_success[$2]++
      } else if ($4 == "failed") {
        failed++
        user_failed[$2]++
      }
    }
    END {
      print "SUMMARY:"
      print "--------"
      print "Total entries: " total
      print "Success count: " success " (" success/total*100 "%)"
      print "Failed count : " failed " (" failed/total*100 "%)"
      print ""
      print "USER STATISTICS:"
      print "--------------"
      for (user in users) {
        print "User " user ": " users[user] " actions (" user_success[user] " success, " user_failed[user] " failed)"
      }
      print ""
      print "ACTION STATISTICS:"
      print "-----------------"
      for (action in actions) {
        print "Action " action ": " actions[action] " occurrences"
      }
    }
  ' "$CSV_FILE"
  
} > "$REPORT_FILE"

echo
echo "Report saved to $REPORT_FILE"