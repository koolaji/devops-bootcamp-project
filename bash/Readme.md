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
