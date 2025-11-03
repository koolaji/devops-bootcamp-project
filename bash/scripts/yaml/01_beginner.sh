#!/bin/bash
# Beginner YAML Configuration Analyzer
# This script performs basic analysis of YAML configuration files

# Default YAML file path or use command line argument if provided
YAML_FILE="${1:-../../examples/services.yaml}"

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

echo "YAML Configuration Analysis Report"
echo "--------------------------------"
echo "Total services: $service_count"
echo

# List services with ports
echo "Services and Ports:"
echo "-----------------"
yq '.services[] | .name + ": " + (.port | tostring)' "$YAML_FILE"