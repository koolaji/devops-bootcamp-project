# Bash Scripting for Log Analysis

This repository contains a collection of Bash scripts for analyzing different types of log files and configuration data, organized by skill level from beginner to advanced.

## Overview

The scripts demonstrate various techniques for parsing and analyzing:
- Text-based log files
- JSON-formatted log files
- CSV-formatted log data
- YAML configuration files

Each section includes beginner, intermediate, and advanced tasks to help you progressively build your bash scripting skills.

## Directory Structure

bash/
├── README.md                     # This documentation
├── examples/                     # Example input files
│   ├── application.log           # Sample application logs in text format
│   ├── activity_log.json         # Sample activity logs in JSON format
│   ├── extended_activity_log.json # Extended JSON log data
│   ├── activity_log.csv          # Sample activity logs in CSV format
│   └── services.yaml             # Sample service configuration in YAML
├── scripts/
│   ├── text/                     # Text log analysis scripts
│   │   ├── 01_beginner.sh        # Basic text log parsing
│   │   ├── 02_intermediate.sh    # More complex text analysis
│   │   └── 03_advanced.sh        # Advanced text processing
│   ├── json/                     # JSON log analysis scripts
│   │   ├── 01_beginner.sh        # Basic JSON parsing
│   │   ├── 02_intermediate.sh    # Intermediate JSON analysis
│   │   └── 03_advanced.sh        # Advanced JSON processing
│   ├── csv/                      # CSV log analysis scripts
│   │   ├── 01_beginner.sh        # Basic CSV parsing
│   │   ├── 02_intermediate.sh    # Intermediate CSV analysis
│   │   └── 03_advanced.sh        # Advanced CSV processing
│   └── yaml/                     # YAML config analysis scripts
│       ├── 01_beginner.sh        # Basic YAML parsing
│       ├── 02_intermediate.sh    # Intermediate YAML analysis
│       └── 03_advanced.sh        # Advanced YAML processing
└── reports/                      # Output directory for generated reports

## Skill Levels

### Beginner Level
- Basic file parsing
- Simple counting and reporting
- Minimal error handling
- Single-purpose scripts

### Intermediate Level
- More complex data extraction
- Filtering and conditional processing
- Basic user input handling
- Formatted output and reporting

### Advanced Level
- Comprehensive data analysis
- Advanced error handling and validation
- Interactive user interfaces
- Complex data transformation and visualization
- Performance optimizations

## Text Log Analysis Tasks

### Beginner
- Count occurrences of different log levels (INFO, WARN, ERROR, etc.)
- Generate a simple summary report
- Basic error handling for missing files

### Intermediate
- Filter logs by date range
- Count entries by hour to identify peak activity times
- Extract and count specific patterns or events
- Generate formatted reports with statistics

### Advanced
- Interactive mode for real-time log analysis
- Pattern detection for anomaly identification
- Correlation analysis between different log events
- Visualization of log trends using ASCII charts
- Export capabilities to different formats

## JSON Log Analysis Tasks

### Beginner
- Count successful vs. failed actions
- List all unique users in the logs
- Basic reporting of totals

### Intermediate
- Group actions by user and calculate statistics
- Detailed analysis of failed actions
- Filter logs by time period or action type
- Generate formatted reports with multiple sections

### Advanced
- Interactive querying of JSON logs
- Complex aggregations and cross-referencing
- Anomaly detection in user behavior
- Integration with monitoring systems
- Performance analysis for processing large JSON files

## CSV Log Analysis Tasks

### Beginner
- Parse basic CSV structure
- Count entries by column values
- Generate simple reports

### Intermediate
- Filter entries by user-specified criteria
- Calculate statistics by grouping data
- Compare different columns and identify patterns
- Generate detailed, well-formatted reports

### Advanced
- Interactive data exploration interface
- Complex data transformations and pivoting
- Multi-file CSV analysis and joining
- Custom report generation with charts
- Performance optimizations for large CSV files

## YAML Configuration Analysis Tasks

### Beginner
- Extract and display service names and ports
- Count services by protocol
- Basic configuration validation

### Intermediate
- Filter services by user-specified criteria
- Validate configuration against best practices
- Compare environment variables across services
- Generate comprehensive configuration reports

### Advanced
- Interactive configuration exploration and modification
- Detect security issues in configurations
- Generate configuration differences between versions
- Create visualization of service relationships
- Implement advanced validation rules

## Prerequisites

- Bash shell (version 4.0 or higher recommended)
- 'jq' command-line tool for JSON processing
- 'yq' command-line tool for YAML processing

## Learning Objectives

- Parsing and processing different data formats in Bash
- Working with command-line tools for structured data
- Implementing progressively complex script features
- Building user interfaces for script interaction
- Developing comprehensive error handling strategies
- Creating well-formatted reports and visualizations