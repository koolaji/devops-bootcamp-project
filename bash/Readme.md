# Bash Scripting for Log Analysis - Teaching Guide

This repository contains educational bash scripts for teaching log analysis techniques. Each script is accompanied by questions and answers to facilitate classroom learning.

## Main Scripts

### 01_text_log_analyzer.sh - Text Log Analysis

**Questions:**
1. What technique does this script use to count different log levels?
   * **Answer:** The script uses a line-by-line reading approach with conditional pattern matching (`if [[ "$line" == *"[INFO]"* ]]`) to identify and count log levels.

2. Why is the `-p` flag used when creating the output directory?
   * **Answer:** The `-p` flag makes `mkdir` create parent directories as needed and prevents errors if the directory already exists, making the script more robust.

3. How would you modify this script to count custom log levels not currently included?
   * **Answer:** Add new counter variables (e.g., `custom_count=0`) and add a new conditional check in the while loop (e.g., `elif [[ "$line" == *"[CUSTOM]"* ]]; then ((custom_count++))`)

### 02_json_log_analyzer.sh - JSON Log Analysis

**Questions:**
1. Why does this script check for the 'jq' command before processing?
   * **Answer:** The script depends on 'jq' for JSON processing. Checking for its presence before starting ensures the script won't fail with cryptic errors midway through execution.

2. How are associative arrays used in this script and what is their purpose?
   * **Answer:** Associative arrays (`declare -A user_action_count`) store data with string keys instead of numeric indices, allowing the script to count actions by user ID as keys.

3. What jq command would you use to extract only failed actions for a specific user?
   * **Answer:** `jq -r '.[] | select(.status == "failed" and .userID == "specific_id")'`

### 03_csv_log_analyzer.sh - CSV Log Analysis

**Questions:**
1. How does this script handle user input to analyze specific users?
   * **Answer:** It uses the `read -p` command to prompt for user input and then constructs different awk commands based on whether the user specified a particular user ID or requested all users.

2. What field separator does awk use in this script and why?
   * **Answer:** It uses `-F','` to specify a comma as the field separator, which is appropriate for CSV files where fields are comma-separated.

3. How does the script generate different reports based on user selection?
   * **Answer:** It uses conditional logic (`if [[ -z "$user_id" ]]`) to determine whether to run the awk script for all users or for a specific user, generating appropriate output in each case.

### 04_yaml_config_analyzer.sh - YAML Configuration Analysis

**Questions:**
1. Why is the 'yq' tool required for this script?
   * **Answer:** YAML files have hierarchical structures that are difficult to parse with standard bash tools. 'yq' provides specialized functionality for querying and manipulating YAML data.

2. How does the script extract a list of available services?
   * **Answer:** It uses the command `yq '.services[].name' "$YAML_FILE"` to extract the name field from each service in the services array.

3. What technique does this script use to generate different reports for specific services vs. all services?
   * **Answer:** The script uses conditional logic based on user input and creates different report structures using yq with appropriate queries for either all services or a specific service.

## Format-Specific Scripts

### Text Log Scripts (text directory)

#### 01_beginner.sh

**Questions:**
1. What is the primary purpose of this beginner script?
   * **Answer:** To demonstrate basic text log parsing and counting log levels using simple pattern matching.

2. How does the script check if a log file exists?
   * **Answer:** It uses the bash test command `if [[ ! -f "$LOG_FILE" ]]` to check if the file exists and is a regular file.

3. What would happen if the log contained a line with both "[INFO]" and "[ERROR]"?
   * **Answer:** The script would only count it as INFO because it uses an if-elif structure that stops after the first match.

#### 02_intermediate.sh

**Questions:**
1. How does this intermediate script improve on the beginner version?
   * **Answer:** It adds functionality like filtering by date range, counting entries by hour, and generating more detailed reports.

2. Explain how the script extracts timestamps from log entries.
   * **Answer:** It uses regex pattern matching with `=~` to extract date and time components from log lines.

3. How could you modify this script to group logs by both hour and log level?
   * **Answer:** Create a nested associative array or combine the hour and log level as a composite key in a single associative array.

#### 03_advanced.sh

**Questions:**
1. What advanced features does this script implement?
   * **Answer:** Interactive menus, real-time log monitoring, pattern detection for anomalies, and visualization of log trends.

2. How does the script create ASCII charts for visualization?
   * **Answer:** It calculates proportional bar widths based on values and uses string repetition to create visual bars.

3. Explain the purpose of the `trap` command in this script.
   * **Answer:** It catches user interruption signals (Ctrl+C) to perform cleanup tasks before exiting, ensuring resources are properly released.

### JSON Log Scripts (json directory)

#### 01_beginner.sh

**Questions:**
1. What basic statistics does this script calculate from JSON logs?
   * **Answer:** It counts successful vs. failed actions, total entries, and unique users in the JSON data.

2. What advantage does using 'jq' provide over standard text processing tools?
   * **Answer:** 'jq' understands JSON structure, allowing direct querying of nested data without complex string parsing.

3. How would you modify this script to also count unique action types?
   * **Answer:** Add the line `unique_actions=$(jq '[.[].action] | unique | length' "$JSON_FILE")`

#### 02_intermediate.sh

**Questions:**
1. What additional analysis does this script perform beyond the beginner script?
   * **Answer:** It calculates actions by user, detailed analysis of failed actions, and filters by time period.

2. How does the script group actions by user ID?
   * **Answer:** It uses jq to select actions for each user and then counts them, storing results in associative arrays.

3. What technique is used to format the output into sections?
   * **Answer:** The script uses echo statements with line separators and section headers to create distinct report sections.

#### 03_advanced.sh

**Questions:**
1. How does this script implement an interactive menu system?
   * **Answer:** It uses a function `display_menu()` with a case statement to handle different menu options selected by the user.

2. What techniques does the script use for anomaly detection?
   * **Answer:** It calculates average actions per user and identifies users with activity significantly above or below this average.

3. How does the script generate an HTML report?
   * **Answer:** It uses a series of echo statements with HTML tags and CSS styling, dynamically inserting data from the analysis.

### CSV Log Scripts (csv directory)

#### 01_beginner.sh

**Questions:**
1. How does this script parse CSV data differently than JSON or text logs?
   * **Answer:** It uses awk with a field separator `-F','` to process structured tabular data by column.

2. What basic counting operations does the script perform?
   * **Answer:** It counts entries by column values and generates simple summary statistics.

3. How would you modify this script to handle CSV files with a header row?
   * **Answer:** Add a conditional `if (NR == 1) { next }` in the awk script to skip the first row.

#### 02_intermediate.sh

**Questions:**
1. What filtering capabilities does this script implement?
   * **Answer:** It allows filtering by date range, user, action type, and status using awk conditionals.

2. How does the script calculate statistics by grouping data?
   * **Answer:** It uses associative arrays in awk to accumulate statistics for different groups.

3. How are command-line arguments processed in this script?
   * **Answer:** It uses a while loop with getopts to process flags and their values from the command line.

#### 03_advanced.sh

**Questions:**
1. What advanced data analysis techniques does this script demonstrate?
   * **Answer:** Pivoting data, time-series analysis, correlation between columns, and interactive exploration.

2. How does the script generate visualizations from CSV data?
   * **Answer:** It processes the data with awk and uses proportional character repetition to create ASCII charts.

3. What approach does the script use to handle large CSV files efficiently?
   * **Answer:** It processes the file in a single pass using awk, avoiding multiple reads of the same file.

### YAML Config Scripts (yaml directory)

#### 01_beginner.sh

**Questions:**
1. What basic information does this script extract from YAML files?
   * **Answer:** It counts the total number of services and lists service names with their ports.

2. Why is the 'yq' tool specifically needed for this task?
   * **Answer:** YAML has significant whitespace and hierarchical structure that requires specialized parsing tools.

3. How would you modify this script to also display service protocols?
   * **Answer:** Add a line using yq to extract the protocol field: `yq '.services[] | .name + ": " + .protocol' "$YAML_FILE"`

#### 02_intermediate.sh

**Questions:**
1. What filtering capabilities does this script implement for YAML data?
   * **Answer:** It allows filtering services by port ranges, protocols, and environment variable presence.

2. How does the script validate configuration against best practices?
   * **Answer:** It checks for missing required fields, insecure defaults, and configuration patterns that violate best practices.

3. What technique does the script use to compare values across different services?
   * **Answer:** It extracts specific fields from all services into arrays and then uses loops to compare values between them.

#### 03_advanced.sh

**Questions:**
1. What advanced features does this script implement for YAML analysis?
   * **Answer:** Interactive exploration, security scanning, configuration difference detection, and relationship visualization.

2. How does the script detect security issues in service configurations?
   * **Answer:** It checks for patterns like hardcoded credentials, insecure ports, missing authentication, and uses a scoring system.

3. What approach is used to visualize service relationships?
   * **Answer:** It creates an ASCII-based network diagram showing connections between services based on their configuration dependencies.

## Teaching Notes

- Start with the beginner scripts to establish core concepts
- Demonstrate how the same task gets more sophisticated across skill levels
- Have students modify scripts to handle different log formats or add features
- Encourage students to create their own scripts based on these patterns
- Use the provided questions as class discussion points or quiz material

## Prerequisites for Students

- Basic understanding of bash syntax
- Familiarity with command-line tools
- Access to a bash shell environment (Linux/Mac/WSL)
- Sample log files for hands-on practice