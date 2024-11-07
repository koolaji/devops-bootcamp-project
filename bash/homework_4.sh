#!/bin/bash

# Path to the YAML file
YAML_FILE="services.yaml"

# Check if the YAML file exists
if [[ ! -f "$YAML_FILE" ]]; then
    echo "YAML file not found! Please ensure that '$YAML_FILE' exists."
    exit 1
fi

# Prompt the user for a service name
read -p "Enter the service name to analyze: " service_name

# Check if the input is empty
if [[ -z "$service_name" ]]; then
    echo "No service name provided. Exiting."
    exit 1
fi

# Use yq to check if the service exists and generate a detailed report
report=$(yq --arg service_name "$service_name" '
  .services[] | select(.name == $service_name) | 
  { name: .name, port: .port, protocol: .protocol, env: .env }' "$YAML_FILE")

# Check if the report is empty (service not found)
if [[ -z "$report" ]]; then
    echo "Service '$service_name' not found in the configuration."
    exit 1
fi

# Generate the detailed report
echo "Detailed Report for Service: $service_name"
echo "-----------------------------------------"
echo "$report" | yq -r '. | "Name: \(.name)\nPort: \(.port)\nProtocol: \(.protocol)"'

# Check if there are environment variables and display them
env_vars=$(echo "$report" | yq -r '.env[]? | "Name: \(.NAME), Value: \(.VALUE)"')

if [[ -n "$env_vars" ]]; then
    echo -e "\nEnvironment Variables:"
    echo "$env_vars"
else
    echo -e "\nNo Environment Variables defined for this service."
fi

