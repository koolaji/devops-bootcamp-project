#!/bin/bash
# Intermediate YAML Configuration Analyzer
# This script performs more detailed analysis of YAML configuration files

# Default YAML file path or use command line argument if provided
YAML_FILE="${1:-../../examples/services.yaml}"
OUTPUT_DIR="../../reports"
REPORT_FILE="$OUTPUT_DIR/yaml_analysis_report.txt"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if the YAML file exists
if [[ ! -f "$YAML_FILE" ]]; then
  echo "Error: YAML file '$YAML_FILE' not found!"
  exit 1
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
  echo "Error: yq is not installed!"
  echo "Please install yq before running this script."
  exit 1
fi

echo "Analyzing YAML configuration file: $YAML_FILE"
echo

# Count services
service_count=$(yq '.services | length' "$YAML_FILE")

# Count services by protocol
tcp_count=$(yq '.services[] | select(.protocol == "tcp") | .name' "$YAML_FILE" | wc -l)
udp_count=$(yq '.services[] | select(.protocol == "udp") | .name' "$YAML_FILE" | wc -l)

# Count services with environment variables
env_count=$(yq '.services[] | select(.env != null and .env != []) | .name' "$YAML_FILE" | wc -l)

echo "YAML Configuration Analysis Report"
echo "--------------------------------"
echo "Total services: $service_count"
echo "TCP services  : $tcp_count"
echo "UDP services  : $udp_count"
echo "Services with environment variables: $env_count"
echo

# List services with ports and protocols
echo "Services, Ports, and Protocols:"
echo "-----------------------------"
yq '.services[] | .name + ": Port " + (.port | tostring) + " (" + .protocol + ")"' "$YAML_FILE"
echo

# Prompt user for filtering options
echo "Filter options:"
echo "1. Show services by protocol"
echo "2. Show services with environment variables"
echo "3. Show services with ports in a specific range"
echo "4. Show specific service details"
read -p "Select an option (1-4): " filter_option

case $filter_option in
  1)
    read -p "Enter protocol (tcp/udp): " protocol
    echo
    echo "Services using $protocol protocol:"
    echo "------------------------------"
    yq -r --arg proto "$protocol" '.services[] | select(.protocol == $proto) | .name + ": Port " + (.port | tostring)' "$YAML_FILE"
    ;;
  2)
    echo
    echo "Services with environment variables:"
    echo "---------------------------------"
    yq -r '.services[] | select(.env != null and .env != []) | .name + ": " + (.env | length | tostring) + " variables"' "$YAML_FILE"
    
    # Show environment variables for each service
    services_with_env=$(yq -r '.services[] | select(.env != null and .env != []) | .name' "$YAML_FILE")
    echo
    for service in $services_with_env; do
      echo "Environment variables for $service:"
      yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .env[] | "  " + .NAME + ": " + .VALUE' "$YAML_FILE"
      echo
    done
    ;;
  3)
    read -p "Enter minimum port: " min_port
    read -p "Enter maximum port: " max_port
    echo
    echo "Services with ports between $min_port and $max_port:"
    echo "----------------------------------------------"
    yq -r --arg min "$min_port" --arg max "$max_port" '.services[] | select(.port >= ($min | tonumber) and .port <= ($max | tonumber)) | .name + ": Port " + (.port | tostring)' "$YAML_FILE"
    ;;
  4)
    echo "Available services:"
    yq -r '.services[].name' "$YAML_FILE"
    read -p "Enter service name: " service_name
    echo
    echo "Details for service '$service_name':"
    echo "--------------------------------"
    service_details=$(yq -r --arg svc "$service_name" '.services[] | select(.name == $svc)' "$YAML_FILE")
    if [[ -z "$service_details" ]]; then
      echo "Service not found!"
    else
      yq -r --arg svc "$service_name" '.services[] | select(.name == $svc) | "Name: " + .name + "\nPort: " + (.port | tostring) + "\nProtocol: " + .protocol' "$YAML_FILE"
      
      # Check for environment variables
      env_vars=$(yq -r --arg svc "$service_name" '.services[] | select(.name == $svc) | .env[]? | "  " + .NAME + ": " + .VALUE' "$YAML_FILE")
      if [[ -n "$env_vars" ]]; then
        echo "Environment Variables:"
        echo "$env_vars"
      else
        echo "No environment variables defined."
      fi
    fi
    ;;
  *)
    echo "Invalid option!"
    ;;
esac

# Generate the report file with all statistics
{
  echo "YAML CONFIGURATION ANALYSIS REPORT"
  echo "=================================="
  echo "Generated on: $(date)"
  echo "Configuration file: $YAML_FILE"
  echo "=================================="
  echo
  
  echo "SUMMARY:"
  echo "--------"
  echo "Total services: $service_count"
  echo "TCP services  : $tcp_count"
  echo "UDP services  : $udp_count"
  echo "Services with environment variables: $env_count"
  echo
  
  echo "SERVICES DETAILS:"
  echo "----------------"
  yq -r '.services[] | "Service: " + .name + "\n  Port: " + (.port | tostring) + "\n  Protocol: " + .protocol' "$YAML_FILE"
  echo
  
  echo "ENVIRONMENT VARIABLES:"
  echo "--------------------"
  services_with_env=$(yq -r '.services[] | select(.env != null and .env != []) | .name' "$YAML_FILE")
  if [[ -z "$services_with_env" ]]; then
    echo "No services with environment variables."
  else
    for service in $services_with_env; do
      echo "Service: $service"
      yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .env[] | "  " + .NAME + ": " + .VALUE' "$YAML_FILE"
      echo
    done
  fi
  
  echo "PORT USAGE ANALYSIS:"
  echo "------------------"
  echo "Port range: $(yq -r '.services | min_by(.port) | .port' "$YAML_FILE") - $(yq -r '.services | max_by(.port) | .port' "$YAML_FILE")"
  echo "Average port: $(yq -r '.services | [.[].port] | add / length' "$YAML_FILE")"
  echo
  
} > "$REPORT_FILE"

echo
echo "Report saved to $REPORT_FILE"