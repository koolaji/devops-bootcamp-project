### Project: Application Log Analysis
*_Goal_*: Parse a log file to identify the number of each type of log entry (e.g., ERROR, WARN, INFO) and output a report summarizing these counts.

*Step 1*: Sample Log File Creation  
Provide a sample log file, application.log,   which students will analyze.

Sample application.log Content:
```log
2024-10-30 10:15:32 [INFO] Application started
2024-10-30 10:16:35 [ERROR] Failed to connect to database
2024-10-30 10:17:42 [WARN] Low memory
2024-10-30 10:18:45 [INFO] User logged in
2024-10-30 10:20:55 [ERROR] File not found
2024-10-30 10:21:33 [INFO] Data saved successfully
2024-10-30 10:22:41 [WARN] Disk usage high
```
Step 2: Script to Parse the Log File  
*File*: parse_logs.sh
```bash
#!/bin/bash

# Path to the log file
LOG_FILE="application.log"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file not found!"
  exit 1
fi

# Initialize counters for each log level
info_count=0
warn_count=0
error_count=0

# Read the log file line by line
while IFS= read -r line; do
  # Check for each log level and update counters
  if [[ "$line" == *"[INFO]"* ]]; then
    ((info_count++))
  elif [[ "$line" == *"[WARN]"* ]]; then
    ((warn_count++))
  elif [[ "$line" == *"[ERROR]"* ]]; then
    ((error_count++))
  fi
done < "$LOG_FILE"

# Output the results
echo "Log Analysis Report"
echo "--------------------"
echo "INFO count : $info_count"
echo "WARN count : $warn_count"
echo "ERROR count: $error_count"
```

Step 3: Run the Script  
Make the script executable and run it:
```bash
chmod +x parse_logs.sh
./parse_logs.sh
```
*Expected Output*
When students run the script, they should see output similar to this:
```
Log Analysis Report
--------------------
INFO count : 3
WARN count : 2
ERROR count: 2
```

#### Homework
```
2024-10-30 08:03:12 [INFO] Starting application process
2024-10-30 08:05:45 [DEBUG] Initialized database connection pool
2024-10-30 08:06:33 [INFO] User authenticated: user_id=12345
2024-10-30 08:07:15 [WARN] Memory usage is above threshold
2024-10-30 08:08:24 [ERROR] Failed to fetch data from API - timeout
2024-10-30 08:09:55 [FATAL] System out of memory, shutting down immediately
2024-10-30 08:10:01 [INFO] Data processing completed successfully
2024-10-30 08:12:47 [ERROR] Disk I/O error detected
2024-10-30 08:13:59 [FATAL] Database corruption detected - immediate maintenance required
2024-10-30 08:15:30 [DEBUG] Cache refreshed for user_id=12345
2024-10-30 08:18:22 [INFO] New session started for user_id=67890
2024-10-30 08:20:55 [WARN] High CPU usage detected
2024-10-30 08:25:19 [ERROR] Unable to connect to database
2024-10-30 08:26:43 [INFO] Application shutdown initiated
2024-10-30 08:28:11 [FATAL] Fatal configuration error - unable to continue
2024-10-30 08:30:09 [INFO] Application shutdown completed
2024-10-30 08:32:56 [DEBUG] Debugging mode enabled by user_id=67890
2024-10-30 08:35:42 [WARN] Low disk space warning
2024-10-30 08:37:13 [INFO] Scheduled maintenance started
2024-10-30 08:40:28 [INFO] Scheduled maintenance completed
2024-10-30 08:43:55 [ERROR] Permission denied for user_id=55555
2024-10-30 08:47:10 [INFO] New feature flag enabled: dark_mode
2024-10-30 08:50:36 [WARN] Deprecated API called
2024-10-30 08:53:49 [ERROR] Unexpected application crash detected
2024-10-30 08:55:01 [FATAL] Kernel panic - critical system failure
```
### Task 2: Parsing a JSON Log File
*Goal*: Teach students how to process JSON   files in Bash, focusing on extracting values, counting occurrences, and summarizing data.  

#### Step 1: Sample JSON Log File Creation  
Provide a sample JSON log file, activity_log.json, for students to analyze.  

Sample activity_log.json Content:
```log 
[
  {"timestamp": "2024-10-30T09:00:01Z", "userID": 12345, "action": "login", "status": "success"},
  {"timestamp": "2024-10-30T09:05:32Z", "userID": 12345, "action": "view_page", "status": "success"},
  {"timestamp": "2024-10-30T09:10:45Z", "userID": 67890, "action": "login", "status": "failed"},
  {"timestamp": "2024-10-30T09:12:15Z", "userID": 67890, "action": "view_page", "status": "success"},
  {"timestamp": "2024-10-30T09:15:30Z", "userID": 12345, "action": "logout", "status": "success"},
  {"timestamp": "2024-10-30T09:20:01Z", "userID": 67890, "action": "logout", "status": "failed"},
  {"timestamp": "2024-10-30T09:22:11Z", "userID": 12345, "action": "upload_file", "status": "success"},
  {"timestamp": "2024-10-30T09:25:55Z", "userID": 67890, "action": "upload_file", "status": "success"},
  {"timestamp": "2024-10-30T09:30:01Z", "userID": 67890, "action": "delete_file", "status": "success"},
  {"timestamp": "2024-10-30T09:35:15Z", "userID": 12345, "action": "view_page", "status": "failed"}
]
```
#### Step 2: Script to Parse the JSON File
Students can use the jq command-line tool to parse the JSON data. Ensure that they have jq installed. Here's the script they will create.

File: parse_json_log.sh
```bash
#!/bin/bash

# Path to the JSON log file
JSON_FILE="activity_log.json"

# Check if the JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
  echo "JSON file not found! Please ensure that '$JSON_FILE' exists."
  exit 1
fi

# Initialize counters
success_count=0
failed_count=0

# Read the JSON file and count successes and failures
success_count=$(jq '[.[] | select(.status == "success")] | length' "$JSON_FILE")
failed_count=$(jq '[.[] | select(.status == "failed")] | length' "$JSON_FILE")

# Output the results
echo "JSON Log Analysis Report"
echo "------------------------"
echo "Total Success Actions: $success_count"
echo "Total Failed Actions  : $failed_count"

# Save the report to a file
REPORT_FILE="json_log_analysis_report.txt"
{
  echo "JSON Log Analysis Report"
  echo "------------------------"
  echo "Total Success Actions: $success_count"
  echo "Total Failed Actions  : $failed_count"
} > "$REPORT_FILE"

echo "Report saved to '$REPORT_FILE'."
```
#### Step 3: Run the Script
Make the script executable and run it:
```bash
chmod +x parse_json_log.sh
./parse_json_log.sh
```
#### Expected Output
When students run the script, they should see output similar to this:
```log 
JSON Log Analysis Report
------------------------
Total Success Actions: 6
Total Failed Actions  : 3
Report saved to 'json_log_analysis_report.txt'.
```
#### homework
```log 
[
  {"timestamp": "2024-10-30T09:00:01Z", "userID": 12345, "action": "login", "status": "success"},
  {"timestamp": "2024-10-30T09:05:32Z", "userID": 12345, "action": "view_page", "status": "success"},
  {"timestamp": "2024-10-30T09:10:45Z", "userID": 67890, "action": "login", "status": "failed"},
  {"timestamp": "2024-10-30T09:12:15Z", "userID": 67890, "action": "view_page", "status": "success"},
  {"timestamp": "2024-10-30T09:15:30Z", "userID": 12345, "action": "logout", "status": "success"},
  {"timestamp": "2024-10-30T09:20:01Z", "userID": 67890, "action": "logout", "status": "failed"},
  {"timestamp": "2024-10-30T09:22:11Z", "userID": 12345, "action": "upload_file", "status": "success"},
  {"timestamp": "2024-10-30T09:25:55Z", "userID": 67890, "action": "upload_file", "status": "success"},
  {"timestamp": "2024-10-30T09:30:01Z", "userID": 67890, "action": "delete_file", "status": "success"},
  {"timestamp": "2024-10-30T09:35:15Z", "userID": 12345, "action": "view_page", "status": "failed"},
  {"timestamp": "2024-10-30T09:40:10Z", "userID": 12345, "action": "login", "status": "success"},
  {"timestamp": "2024-10-30T09:42:00Z", "userID": 67890, "action": "upload_file", "status": "failed"},
  {"timestamp": "2024-10-30T09:45:55Z", "userID": 12345, "action": "delete_file", "status": "success"},
  {"timestamp": "2024-10-30T09:48:33Z", "userID": 67890, "action": "view_page", "status": "success"},
  {"timestamp": "2024-10-30T09:50:30Z", "userID": 67890, "action": "logout", "status": "success"}
]
```
#### homework
#### Explanation of Extended Log Entries
Diverse Actions: The log includes various actions (login, view_page, logout, upload_file, delete_file) to provide a broad spectrum for analysis.  
Multiple Statuses: Each action has a status of either success or failed, allowing for a detailed count and analysis of successful versus failed actions.  
Timestamp: Each entry includes a timestamp, which is useful for temporal analysis, such as counting actions within specific time frames.   
Suggested Extensions for the Analysis Script
Count Actions by User: Modify the script to count the number of actions performed by each user and print that information in the report.   

Filter by User ID: Allow users to input a specific user ID when running the script to filter the report to that user’s actions.   

Detailed Report of Failed Attempts: Extend the report to include timestamps and actions for all failed attempts, presenting them in a list format.  

#### Overview of the Task3
_Objective_: Teach students how to process CSV files in Bash, focusing on column selection and data extraction.

Instructions:

Create the CSV Log File: Save the provided sample CSV content in a file named activity_log.csv.

Bash Script: Students should write a Bash script (parse_csv_log.sh) that performs the following tasks:  

Uses cut, awk, or IFS to select specific columns (e.g., Timestamp and Status).
Counts how many times each user appears in the log.  
Generates a summary of actions per user.
Example Script for Students: parse_csv_log.sh
Here's an example Bash script to guide the students in completing the task:  
```log
Timestamp,UserID,Action,Status
2024-10-30 09:00:01,12345,login,success
2024-10-30 09:05:32,12345,view_page,success
2024-10-30 09:10:45,67890,login,failed
2024-10-30 09:12:15,67890,view_page,success
2024-10-30 09:15:30,12345,logout,success
2024-10-30 09:20:01,67890,logout,failed
2024-10-30 09:25:45,12345,upload_file,success
2024-10-30 09:30:00,67890,upload_file,success
2024-10-30 09:35:15,12345,view_page,failed
2024-10-30 09:40:10,67890,delete_file,success
```
```bash
#!/bin/bash

# Path to the CSV log file
CSV_FILE="activity_log.csv"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "CSV file not found! Please ensure that '$CSV_FILE' exists."
    exit 1
fi

# Initialize an associative array to count actions per user
declare -A user_count

# Read the CSV file line by line, skipping the header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r timestamp user_id action status; do
    # Increment the user count
    ((user_count[$user_id]++))
done

# Output the summary report
echo "User Action Summary:"
echo "---------------------"
for user_id in "${!user_count[@]}"; do
    echo "UserID: $user_id | Actions Count: ${user_count[$user_id]}"
done
```
```bash
#!/bin/bash

# Path to the CSV log file
CSV_FILE="activity_log.csv"

# Check if the CSV file exists
if [[ ! -f "$CSV_FILE" ]]; then
    echo "CSV file not found! Please ensure that '$CSV_FILE' exists."
    exit 1
fi

# Use awk to count actions per user and display timestamps and statuses
awk -F',' '
NR > 1 { 
    user_count[$2]++                   # Count actions per UserID
    print $1, $2, $4                   # Print Timestamp, UserID, and Status
}
END { 
    print "\nUser Action Summary:"
    print "---------------------"
    for (user_id in user_count) {
        print "UserID: " user_id " | Actions Count: " user_count[user_id]
    }
}' "$CSV_FILE"
```

Advanced Task: Comprehensive Log Analysis with Filtering and Reporting (1.5 hours)
Objective: Write a Bash script that analyzes a CSV log file and generates detailed reports based on user input, including error handling and filtering capabilities.  

Activity Overview
Log File: Use the CSV log file activity_log.csv provided in previous tasks.
Bash Script: Create a script (advanced_log_analysis.sh) that:
Prompts the user for a specific UserID to filter actions.
Validates the input and checks if the UserID exists in the log.
Generates a detailed report for that user, including:
Total actions performed.
Counts of successful and failed actions.
A chronological list of actions performed by the user with timestamps.
Includes error handling for invalid user input and provides appropriate feedback.
Sample CSV Log File: activity_log.csv
```log
Timestamp,UserID,Action,Status
2024-10-30 09:00:01,12345,login,success
2024-10-30 09:05:32,12345,view_page,success
2024-10-30 09:10:45,67890,login,failed
2024-10-30 09:12:15,67890,view_page,success
2024-10-30 09:15:30,12345,logout,success
2024-10-30 09:20:01,67890,logout,failed
2024-10-30 09:25:45,12345,upload_file,success
2024-10-30 09:30:00,67890,upload_file,success
2024-10-30 09:35:15,12345,view_page,failed
2024-10-30 09:40:10,67890,delete_file,success
```

#### Task 4: Parsing YAML Configurations (1 hour)
Objective: Familiarize students with handling YAML files in Bash, specifically using yq as a YAML parser to extract specific fields.

#### Activity Overview
YAML File: Provide a sample YAML file that contains configuration details for multiple services.
Bash Script: Create a script (parse_yaml.sh) that:
Uses yq to extract the names and ports of all services.
Generates a report listing each service with its respective port.
```yaml
services:
  - name: web
    port: 80
    protocol: tcp
  - name: database
    port: 5432
    protocol: tcp
  - name: cache
    port: 6379
    protocol: tcp
  - name: message_queue
    port: 5672
    protocol: tcp
```

```bash
#!/bin/bash

# Path to the YAML file
YAML_FILE="services.yaml"

# Check if the YAML file exists
if [[ ! -f "$YAML_FILE" ]]; then
    echo "YAML file not found! Please ensure that '$YAML_FILE' exists."
    exit 1
fi

# Use yq to extract service names and ports
echo "Service Port Report:"
echo "----------------------"

# Extract services and their respective ports
yq '.services[] | "\(.name): \(.port)"' "$YAML_FILE"
```
#### Advanced Homework: Comprehensive YAML Configuration Analysis (2 hours)
Objective: Write a Bash script that analyzes a YAML configuration file, extracting and reporting detailed information based on user-defined criteria.

Activity Overview
YAML File: Provide a sample YAML file containing configurations for various services, including additional metadata.
Bash Script: Create a script (advanced_yaml_analysis.sh) that:
Prompts the user to specify a service name.
Validates the user input and checks if the specified service exists.
Generates a detailed report that includes:
The service name.
The port number.
The protocol.
Additional metadata (e.g., environment variables).
If the service has environment variables, the script should list them.
```yaml
services:
  - name: web
    port: 80
    protocol: tcp
    env:
      - NAME: "WEBSITE_NAME"
        VALUE: "MyWebsite"
  - name: database
    port: 5432
    protocol: tcp
    env:
      - NAME: "DB_USER"
        VALUE: "admin"
      - NAME: "DB_PASS"
        VALUE: "securepassword"
  - name: cache
    port: 6379
    protocol: tcp
    env: []
  - name: message_queue
    port: 5672
    protocol: tcp
    env:
      - NAME: "MQ_USER"
        VALUE: "mquser"
```


#### Homework: Automating Tasks with Crontab (1 hour)
Objective: Learn how to use crontab to schedule automated tasks, enhancing system management and maintenance skills.

Activity Overview
Task Description: Students will create a Bash script that performs a simple task, such as backing up a directory or logging system information. They will then schedule this script to run at regular intervals using crontab.

Bash Script: Create a script (backup.sh) that:

Backs up a specified directory to a backup location.
Logs the date and time of each backup in a log file.
```bash 
#!/bin/bash

# Directory to back up
SOURCE_DIR="/path/to/source_directory"
# Backup destination
BACKUP_DIR="/path/to/backup_directory"
# Log file
LOG_FILE="/path/to/backup_log.txt"

# Create a backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform the backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

if tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"; then
    echo "Backup successful: $BACKUP_FILE" >> "$LOG_FILE"
    echo "Backup performed on $(date)" >> "$LOG_FILE"
else
    echo "Backup failed for $SOURCE_DIR" >> "$LOG_FILE"
fi
```
```bash 
crontab -e
0 2 * * * /path/to/backup.sh
```