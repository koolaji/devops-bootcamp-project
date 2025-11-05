#!/bin/bash
#########################################################
# YAML Configuration Analyzer
#
# This script analyzes YAML configuration files to extract
# and report details about services, including ports,
# protocols, and environment variables.
#
# Usage: ./04_yaml_config_analyzer.sh [yaml_file_path]
#########################################################

# Default YAML file path or use command line argument if provided
YAML_FILE="${1:-../examples/services.yaml}"
OUTPUT_DIR="../reports"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Print script header
echo "==============================================" 
echo "          YAML CONFIGURATION ANALYZER          "
echo "=============================================="
echo

# Check if the YAML file exists
if [[ ! -f "$YAML_FILE" ]]; then
    echo "❌ Error: YAML file '$YAML_FILE' not found!"
    echo "Please provide a valid YAML file path or create the default one."
    exit 1
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "❌ Error: yq is not installed!"
    echo "Please install yq before running this script."
    echo "Installation: pip install yq"
    echo "or: brew install yq (macOS)"
    exit 1
fi

# List available services
echo "📊 Available services in the configuration file:"
echo "----------------------------------------------"
yq '.services[].name' "$YAML_FILE"
echo

# Prompt the user for a service name
read -p "Enter the service name to analyze (or press Enter for all services): " service_name

# Generate appropriate output file name
if [[ -z "$service_name" ]]; then
    REPORT_FILE="$OUTPUT_DIR/yaml_config_all_services.txt"
    echo "📊 Analyzing all services..."
else
    REPORT_FILE="$OUTPUT_DIR/yaml_config_${service_name}.txt"
    echo "📊 Analyzing service: $service_name"
fi

# Generate the report based on user input
if [[ -z "$service_name" ]]; then
    # Report for all services
    {
        echo "YAML CONFIGURATION ANALYSIS - ALL SERVICES"
        echo "=============================================="
        echo "Generated on: $(date)"
        echo "Source file : $YAML_FILE"
        echo "=============================================="
        echo
        
        # Loop through each service
        yq '.services[] | "SERVICE: \(.name)\n-----------------------\nPort: \(.port)\nProtocol: \(.protocol)\n"' "$YAML_FILE"
        
        # Process environment variables for all services
        echo "ENVIRONMENT VARIABLES BY SERVICE:"
        echo "=============================================="
        yq '.services[] | "SERVICE: \(.name)\n-----------------------\(if .env then "\nEnvironment Variables:" else "\nNo Environment Variables" end)"' "$YAML_FILE"
        
        # For services with environment variables, list them
        yq '.services[] | select(.env != null and .env != []) | .name as $name | .env[] | "  \($name): \(.NAME) = \(.VALUE)"' "$YAML_FILE"
    } > "$REPORT_FILE"
else
    # Report for specific service
    report=$(yq --arg service_name "$service_name" '.services[] | select(.name == $service_name)' "$YAML_FILE")
    
    # Check if the report is empty (service not found)
    if [[ -z "$report" ]]; then
        echo "❌ Service '$service_name' not found in the configuration."
        exit 1
    fi
    
    # Generate the detailed report
    {
        echo "YAML CONFIGURATION ANALYSIS - SERVICE: $service_name"
        echo "=============================================="
        echo "Generated on: $(date)"
        echo "Source file : $YAML_FILE"
        echo "=============================================="
        echo
        
        echo "$report" | yq -r '. | "SERVICE DETAILS:\n-----------------------\nName: \(.name)\nPort: \(.port)\nProtocol: \(.protocol)"'
        
        # Check if there are environment variables and display them
        env_vars=$(echo "$report" | yq -r '.env[]? | "  \(.NAME) = \(.VALUE)"')
        
        if [[ -n "$env_vars" ]]; then
            echo -e "\nENVIRONMENT VARIABLES:"
            echo "-----------------------"
            echo "$env_vars"
        else
            echo -e "\nNo Environment Variables defined for this service."
        fi
    } > "$REPORT_FILE"
fi

echo
echo "✅ Report saved to '$REPORT_FILE'"