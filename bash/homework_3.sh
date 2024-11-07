#!/bin/bash

# Path to the CSV log file
CSV_FILE="activity_log.csv"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "CSV file not found! Please ensure that '$CSV_FILE' exists."
    exit 1
fi

# Prompt the user for a UserID
read -p "Enter UserID to filter: " user_id

# Check if the input is empty
if [[ -z "$user_id" ]]; then
    echo "No UserID provided. Exiting."
    exit 1
fi

# Use awk to check if the UserID exists and generate a report
awk -F',' -v user_id="$user_id" '
NR == 1 { 
    # Store header for later use
    header = $0
    next 
}
{
    # Count actions and categorize by status
    if ($2 == user_id) {
        actions[user_id]++
        if ($4 == "success") {
            successful[user_id]++
        } else {
            failed[user_id]++
        }
        # Collect user actions for output
        user_actions[user_id] = user_actions[user_id] (user_actions[user_id] ? "\n" : "") $1 ", " $3 ", " $4
    }
}
END {
    if (actions[user_id] > 0) {
        print "Report for UserID: " user_id
        print "--------------------------"
        print "Total Actions: " actions[user_id]
        print "Successful Actions: " successful[user_id]
        print "Failed Actions: " failed[user_id]
        print "User Actions:"
        print user_actions[user_id]
    } else {
        print "UserID " user_id " not found in the log."
    }
}' "$CSV_FILE"

