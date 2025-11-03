#!/bin/bash
#########################################################
# CSV Log Analyzer
#
# This script analyzes CSV format logs and generates 
# a detailed user-specific report, showing total actions, 
# successful/failed actions, and a list of all actions.
#
# Usage: ./03_csv_log_analyzer.sh [csv_log_file_path]
#########################################################

# Default CSV log file path or use command line argument if provided
CSV_FILE="${1:-../examples/activity_log.csv}"
OUTPUT_DIR="../reports"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Print script header
echo "==============================================" 
echo "            CSV LOG FILE ANALYZER             "
echo "=============================================="
echo

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "❌ Error: CSV file '$CSV_FILE' not found!"
    echo "Please provide a valid CSV file path or create the default one."
    exit 1
fi

# Show available users in the CSV file
echo "📊 Available users in the log file:"
echo "----------------------------------------------"
awk -F',' 'NR > 1 { users[$2]++ } END { for (user in users) print "UserID: " user }' "$CSV_FILE"
echo

# Prompt the user for a UserID
read -p "Enter UserID to analyze (or press Enter to analyze all): " user_id

# Create a report file name based on user input
if [[ -z "$user_id" ]]; then
    REPORT_FILE="$OUTPUT_DIR/csv_log_analysis_all_users.txt"
    echo "📊 Analyzing all users..."
else
    REPORT_FILE="$OUTPUT_DIR/csv_log_analysis_user_${user_id}.txt"
    echo "📊 Analyzing UserID: $user_id"
fi

# Use awk to generate a report
if [[ -z "$user_id" ]]; then
    # Analysis for all users
    awk -F',' '
    BEGIN {
        print "CSV LOG ANALYSIS REPORT - ALL USERS"
        print "=============================================="
        print "Generated on: " strftime("%Y-%m-%d %H:%M:%S")
        print "Source file : " ARGV[1]
        print "=============================================="
        print ""
    }
    NR == 1 { 
        # Skip header
        next 
    }
    {
        # Count total actions
        total_actions++
        
        # Count actions by user
        user_actions[$2]++
        
        # Count status by user
        if ($4 == "success") {
            user_success[$2]++
            total_success++
        } else {
            user_failed[$2]++
            total_failed++
        }
        
        # Store action details by user
        user_details[$2] = user_details[$2] (user_details[$2] ? "\n" : "") "  " $1 ", " $3 ", " $4
    }
    END {
        print "Total Actions   : " total_actions
        print "Success Actions : " total_success
        print "Failed Actions  : " total_failed
        print ""
        
        print "USER BREAKDOWN"
        print "=============================================="
        for (user in user_actions) {
            print "UserID: " user
            print "  Total Actions   : " user_actions[user]
            print "  Success Actions : " user_success[user]
            print "  Failed Actions  : " user_failed[user]
            print ""
        }
    }' "$CSV_FILE" > "$REPORT_FILE"
else
    # Analysis for specific user
    awk -F',' -v user_id="$user_id" '
    BEGIN {
        print "CSV LOG ANALYSIS REPORT - USER " user_id
        print "=============================================="
        print "Generated on: " strftime("%Y-%m-%d %H:%M:%S")
        print "Source file : " ARGV[1]
        print "=============================================="
        print ""
        found = 0
    }
    NR == 1 { 
        # Skip header
        next 
    }
    {
        if ($2 == user_id) {
            found = 1
            # Count actions and categorize by status
            actions++
            if ($4 == "success") {
                successful++
            } else {
                failed++
            }
            # Collect user actions for output
            user_actions = user_actions (user_actions ? "\n" : "") "  " $1 ", " $3 ", " $4
        }
    }
    END {
        if (found) {
            print "Report for UserID: " user_id
            print "--------------------------"
            print "Total Actions    : " actions
            print "Successful Actions: " successful
            print "Failed Actions   : " failed
            print ""
            print "USER ACTIONS:"
            print "=============================================="
            print user_actions
        } else {
            print "UserID " user_id " not found in the log."
        }
    }' "$CSV_FILE" > "$REPORT_FILE"
fi

echo
echo "✅ Report saved to '$REPORT_FILE'"