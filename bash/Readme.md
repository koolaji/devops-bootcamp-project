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

Optional Extension  
Encourage students to:  

Add date and time of report generation.  
Save the report to a file rather than displaying it on the console.  
Add a feature to extract lines with errors to a separate error report file.  
This setup will give students practical experience with log parsing and basic Bash scripting skills.  