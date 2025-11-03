#!/bin/bash
# Advanced YAML Configuration Analyzer
# This script provides interactive analysis and validation of YAML configuration files

# Default YAML file path or use command line argument if provided
YAML_FILE="${1:-../../examples/services.yaml}"
OUTPUT_DIR="../../reports"
REPORT_PREFIX="advanced_yaml_analysis"

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

# Function to display a horizontal bar chart
display_bar_chart() {
  local title="$1"
  local -n data="$2"
  local max_label_length=0
  local max_value=0
  
  # Find maximum value and label length for formatting
  for label in "${!data[@]}"; do
    (( ${#label} > max_label_length )) && max_label_length=${#label}
    (( ${data[$label]} > max_value )) && max_value=${data[$label]}
  done
  
  echo "$title"
  echo "$(printf '%0.s-' $(seq 1 $((${#title} + 2))))"
  
  # Sort the data by value in descending order
  for label in $(for k in "${!data[@]}"; do echo "$k ${data[$k]}"; done | sort -k2,2nr | cut -d' ' -f1); do
    value=${data[$label]}
    # Calculate bar width proportional to the value (max 50 chars)
    bar_width=$(( value * 50 / (max_value > 0 ? max_value : 1) ))
    printf "%-*s |%s %d\n" "$max_label_length" "$label" "$(printf '%0.s#' $(seq 1 $bar_width))" "$value"
  done
  echo
}

# Function to validate configuration
validate_configuration() {
  local yaml_file="$1"
  local issues=0
  
  echo "Validating configuration..."
  echo
  
  # Check for services without environment variables
  local no_env_services=$(yq -r '.services[] | select(.env == null or .env == []) | .name' "$yaml_file")
  if [[ -n "$no_env_services" ]]; then
    echo "WARNING: Services without environment variables:"
    echo "$no_env_services"
    echo
    ((issues++))
  fi
  
  # Check for duplicate ports
  local duplicate_ports=$(yq -r '.services[].port' "$yaml_file" | sort -n | uniq -d)
  if [[ -n "$duplicate_ports" ]]; then
    echo "ERROR: Duplicate ports detected:"
    for port in $duplicate_ports; do
      echo "Port $port used by:"
      yq -r --arg port "$port" '.services[] | select(.port == ($port | tonumber)) | "  " + .name' "$yaml_file"
    done
    echo
    ((issues++))
  fi
  
  # Check for sensitive environment variables
  local sensitive_vars=$(yq -r '.services[].env[]? | select(.NAME | test("(?i)pass|secret|key|token|credential")) | .NAME' "$yaml_file")
  if [[ -n "$sensitive_vars" ]]; then
    echo "WARNING: Potentially sensitive environment variables detected:"
    echo "$sensitive_vars"
    echo
    ((issues++))
  fi
  
  # Check for missing protocols
  local missing_protocols=$(yq -r '.services[] | select(.protocol == null or .protocol == "") | .name' "$yaml_file")
  if [[ -n "$missing_protocols" ]]; then
    echo "ERROR: Services without protocol specified:"
    echo "$missing_protocols"
    echo
    ((issues++))
  fi
  
  if [[ $issues -eq 0 ]]; then
    echo "No issues found in configuration."
  else
    echo "$issues potential issues found in configuration."
  fi
  echo
}

# Function to visualize service relationships
visualize_services() {
  local yaml_file="$1"
  
  echo "Service Visualization:"
  echo "---------------------"
  echo
  
  # Get all service names
  local services=$(yq -r '.services[].name' "$yaml_file")
  
  # Draw a simple ASCII diagram
  echo "Service Architecture:"
  echo "-------------------"
  echo
  echo "┌─────────────────┐"
  echo "│   Application   │"
  echo "└────────┬────────┘"
  echo "         │"
  echo "         ▼"
  echo "┌─────────────────┐"
  
  for service in $services; do
    port=$(yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .port' "$yaml_file")
    protocol=$(yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .protocol' "$yaml_file")
    printf "│ %-15s │ Port: %-5s Protocol: %-4s\n" "$service" "$port" "$protocol"
    echo "├─────────────────┤"
  done
  
  echo "└─────────────────┘"
  echo
}

# Function to analyze port distribution
analyze_ports() {
  local yaml_file="$1"
  
  echo "Port Distribution Analysis:"
  echo "--------------------------"
  
  # Get port ranges
  local min_port=$(yq -r '.services | min_by(.port) | .port' "$yaml_file")
  local max_port=$(yq -r '.services | max_by(.port) | .port' "$yaml_file")
  local avg_port=$(yq -r '.services | [.[].port] | add / length' "$yaml_file")
  
  echo "Port range: $min_port - $max_port"
  echo "Average port: $avg_port"
  echo
  
  # Count ports by range
  declare -A port_ranges
  port_ranges["0-999"]=$(yq -r '.services[] | select(.port < 1000) | .name' "$yaml_file" | wc -l)
  port_ranges["1000-4999"]=$(yq -r '.services[] | select(.port >= 1000 and .port < 5000) | .name' "$yaml_file" | wc -l)
  port_ranges["5000-9999"]=$(yq -r '.services[] | select(.port >= 5000 and .port < 10000) | .name' "$yaml_file" | wc -l)
  port_ranges["10000+"]=$(yq -r '.services[] | select(.port >= 10000) | .name' "$yaml_file" | wc -l)
  
  # Display chart
  display_bar_chart "Services by Port Range" port_ranges
  
  # List well-known ports (under 1024)
  local well_known=$(yq -r '.services[] | select(.port < 1024) | .name + " (port " + (.port | tostring) + ")"' "$yaml_file")
  if [[ -n "$well_known" ]]; then
    echo "Services using well-known ports (< 1024):"
    echo "$well_known"
    echo
    echo "NOTE: Using well-known ports may require root privileges."
    echo
  fi
}

# Function to generate HTML report
generate_html_report() {
  local yaml_file="$1"
  local timestamp=$(date +"%Y%m%d_%H%M%S")
  local report_file="$OUTPUT_DIR/${REPORT_PREFIX}_${timestamp}.html"
  
  echo "Generating HTML report..."
  
  # Extract data for the report
  local service_count=$(yq '.services | length' "$yaml_file")
  local tcp_count=$(yq '.services[] | select(.protocol == "tcp") | .name' "$yaml_file" | wc -l)
  local udp_count=$(yq '.services[] | select(.protocol == "udp") | .name' "$yaml_file" | wc -l)
  local env_count=$(yq '.services[] | select(.env != null and .env != []) | .name' "$yaml_file" | wc -l)
  local min_port=$(yq -r '.services | min_by(.port) | .port' "$yaml_file")
  local max_port=$(yq -r '.services | max_by(.port) | .port' "$yaml_file")
  
  # Generate the HTML
  {
    echo "<!DOCTYPE html>"
    echo "<html lang=\"en\">"
    echo "<head>"
    echo "  <meta charset=\"UTF-8\">"
    echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    echo "  <title>Advanced YAML Configuration Analysis Report</title>"
    echo "  <style>"
    echo "    body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }"
    echo "    h1 { color: #2c3e50; }"
    echo "    h2 { color: #3498db; margin-top: 30px; }"
    echo "    h3 { color: #2980b9; margin-top: 20px; }"
    echo "    table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }"
    echo "    th, td { text-align: left; padding: 8px; border: 1px solid #ddd; }"
    echo "    th { background-color: #f2f2f2; }"
    echo "    tr:nth-child(even) { background-color: #f9f9f9; }"
    echo "    .warning { color: #f39c12; }"
    echo "    .error { color: #e74c3c; }"
    echo "    .chart-container { margin: 20px 0; max-width: 800px; }"
    echo "    .bar { height: 20px; margin: 5px 0; background-color: #3498db; }"
    echo "    .footer { margin-top: 30px; font-size: 0.8em; color: #7f8c8d; }"
    echo "  </style>"
    echo "</head>"
    echo "<body>"
    echo "  <h1>Advanced YAML Configuration Analysis Report</h1>"
    echo "  <p>Generated on: $(date)</p>"
    echo "  <p>Configuration file: $yaml_file</p>"
    
    echo "  <h2>Summary</h2>"
    echo "  <table>"
    echo "    <tr><th>Metric</th><th>Value</th></tr>"
    echo "    <tr><td>Total Services</td><td>$service_count</td></tr>"
    echo "    <tr><td>TCP Services</td><td>$tcp_count</td></tr>"
    echo "    <tr><td>UDP Services</td><td>$udp_count</td></tr>"
    echo "    <tr><td>Services with Environment Variables</td><td>$env_count</td></tr>"
    echo "    <tr><td>Port Range</td><td>$min_port - $max_port</td></tr>"
    echo "  </table>"
    
    echo "  <h2>Service Details</h2>"
    echo "  <table>"
    echo "    <tr><th>Service</th><th>Port</th><th>Protocol</th><th>Environment Variables</th></tr>"
    
    # List all services
    while IFS= read -r service; do
      port=$(yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .port' "$yaml_file")
      protocol=$(yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .protocol' "$yaml_file")
      env_count=$(yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .env | length // 0' "$yaml_file")
      
      echo "    <tr>"
      echo "      <td>$service</td>"
      echo "      <td>$port</td>"
      echo "      <td>$protocol</td>"
      echo "      <td>$env_count</td>"
      echo "    </tr>"
    done < <(yq -r '.services[].name' "$yaml_file")
    
    echo "  </table>"
    
    echo "  <h2>Environment Variables</h2>"
    echo "  <table>"
    echo "    <tr><th>Service</th><th>Variable</th><th>Value</th></tr>"
    
    # List all environment variables
    while IFS= read -r line; do
      IFS='|' read -r service var_name var_value <<< "$line"
      
      # Check if this might be a sensitive variable
      sensitive=""
      if [[ "$var_name" =~ [Pp][Aa][Ss][Ss]|[Ss][Ee][Cc][Rr][Ee][Tt]|[Kk][Ee][Yy]|[Tt][Oo][Kk][Ee][Nn]|[Cc][Rr][Ee][Dd] ]]; then
        sensitive=" class=\"warning\""
        var_value="***HIDDEN***"
      fi
      
      echo "    <tr$sensitive>"
      echo "      <td>$service</td>"
      echo "      <td>$var_name</td>"
      echo "      <td>$var_value</td>"
      echo "    </tr>"
    done < <(yq -r '.services[] | select(.env != null and .env != []) | .name as $name | .env[] | [$name, .NAME, .VALUE] | join("|")' "$yaml_file")
    
    echo "  </table>"
    
    echo "  <h2>Validation Results</h2>"
    
    # Check for duplicate ports
    duplicate_ports=$(yq -r '.services[].port' "$yaml_file" | sort -n | uniq -d)
    if [[ -n "$duplicate_ports" ]]; then
      echo "  <h3 class=\"error\">Duplicate Ports Detected</h3>"
      echo "  <table>"
      echo "    <tr><th>Port</th><th>Services</th></tr>"
      
      for port in $duplicate_ports; do
        services=$(yq -r --arg port "$port" '.services[] | select(.port == ($port | tonumber)) | .name' "$yaml_file" | paste -sd "," -)
        echo "    <tr class=\"error\">"
        echo "      <td>$port</td>"
        echo "      <td>$services</td>"
        echo "    </tr>"
      done
      
      echo "  </table>"
    else
      echo "  <p>✅ No duplicate ports detected</p>"
    fi
    
    # Check for services without environment variables
    no_env_services=$(yq -r '.services[] | select(.env == null or .env == []) | .name' "$yaml_file")
    if [[ -n "$no_env_services" ]]; then
      echo "  <h3 class=\"warning\">Services Without Environment Variables</h3>"
      echo "  <ul>"
      
      while IFS= read -r service; do
        echo "    <li>$service</li>"
      done <<< "$no_env_services"
      
      echo "  </ul>"
    else
      echo "  <p>✅ All services have environment variables defined</p>"
    fi
    
    echo "  <div class=\"footer\">"
    echo "    <p>This report was generated automatically by the Advanced YAML Configuration Analyzer script.</p>"
    echo "  </div>"
    echo "</body>"
    echo "</html>"
  } > "$report_file"
  
  echo "HTML report saved to: $report_file"
}

# Interactive menu
display_menu() {
  clear
  echo "=== ADVANCED YAML CONFIGURATION ANALYZER ==="
  echo "Configuration File: $YAML_FILE"
  echo
  echo "1. Basic Statistics"
  echo "2. Service Details"
  echo "3. Environment Variable Analysis"
  echo "4. Port Distribution Analysis"
  echo "5. Configuration Validation"
  echo "6. Service Visualization"
  echo "7. Generate HTML Report"
  echo "8. Change Configuration File"
  echo "9. Exit"
  echo
  read -p "Select an option (1-9): " option
  
  case $option in
    1) show_basic_stats ;;
    2) show_service_details ;;
    3) analyze_env_vars ;;
    4) analyze_ports "$YAML_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    5) validate_configuration "$YAML_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    6) visualize_services "$YAML_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    7) generate_html_report "$YAML_FILE"; read -p "Press Enter to continue..."; display_menu ;;
    8) change_config_file ;;
    9) exit 0 ;;
    *) echo "Invalid option"; sleep 2; display_menu ;;
  esac
}

# Show basic statistics
show_basic_stats() {
  clear
  echo "=== BASIC STATISTICS ==="
  echo
  
  # Count services
  service_count=$(yq '.services | length' "$YAML_FILE")
  
  # Count services by protocol
  declare -A protocol_counts
  
  while IFS= read -r protocol; do
    if [[ -n "$protocol" ]]; then
      protocol_counts["$protocol"]=$((${protocol_counts["$protocol"]} + 1))
    fi
  done < <(yq -r '.services[].protocol' "$YAML_FILE")
  
  # Count services with environment variables
  env_count=$(yq '.services[] | select(.env != null and .env != []) | .name' "$YAML_FILE" | wc -l)
  no_env_count=$((service_count - env_count))
  
  echo "Total services: $service_count"
  echo
  
  # Display protocols chart
  display_bar_chart "Services by Protocol" protocol_counts
  
  # Display environment variable chart
  declare -A env_stats
  env_stats["With Env Vars"]=$env_count
  env_stats["Without Env Vars"]=$no_env_count
  display_bar_chart "Environment Variables" env_stats
  
  read -p "Press Enter to continue..."
  display_menu
}

# Show service details
show_service_details() {
  clear
  echo "=== SERVICE DETAILS ==="
  echo
  
  # List all services
  echo "Available services:"
  yq -r '.services[].name' "$YAML_FILE"
  echo
  
  read -p "Enter service name (or press Enter for all): " service_name
  
  if [[ -z "$service_name" ]]; then
    # Show all services
    echo
    echo "All Services:"
    echo "------------"
    
    while IFS= read -r service; do
      echo "Service: $service"
      yq -r --arg svc "$service" '.services[] | select(.name == $svc) | "  Port: " + (.port | tostring) + "\n  Protocol: " + .protocol' "$YAML_FILE"
      
      # Check for environment variables
      env_vars=$(yq -r --arg svc "$service" '.services[] | select(.name == $svc) | .env[]? | "  " + .NAME + ": " + .VALUE' "$YAML_FILE")
      if [[ -n "$env_vars" ]]; then
        echo "  Environment Variables:"
        echo "$env_vars" | sed 's/^/    /'
      else
        echo "  No environment variables defined."
      fi
      echo
    done < <(yq -r '.services[].name' "$YAML_FILE")
  else
    # Show details for specific service
    service_details=$(yq -r --arg svc "$service_name" '.services[] | select(.name == $svc)' "$YAML_FILE")
    
    if [[ -z "$service_details" ]]; then
      echo "Service not found!"
    else
      echo "Details for service '$service_name':"
      echo "--------------------------------"
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
  fi
  
  read -p "Press Enter to continue..."
  display_menu
}

# Analyze environment variables
analyze_env_vars() {
  clear
  echo "=== ENVIRONMENT VARIABLE ANALYSIS ==="
  echo
  
  # Count services with and without environment variables
  env_count=$(yq '.services[] | select(.env != null and .env != []) | .name' "$YAML_FILE" | wc -l)
  service_count=$(yq '.services | length' "$YAML_FILE")
  no_env_count=$((service_count - env_count))
  
  echo "Services with environment variables: $env_count"
  echo "Services without environment variables: $no_env_count"
  echo
  
  # Count total environment variables
  total_env_vars=$(yq '.services[].env[]? | .NAME' "$YAML_FILE" | wc -l)
  echo "Total environment variables: $total_env_vars"
  echo
  
  # Show services with most environment variables
  echo "Services with most environment variables:"
  echo "--------------------------------------"
  yq -r '.services | sort_by(.env | length) | reverse | .[0:5] | .[] | .name + ": " + (.env | length | tostring) + " variables"' "$YAML_FILE"
  echo
  
  # Check for potential sensitive variables
  sensitive_vars=$(yq -r '.services[].env[]? | select(.NAME | test("(?i)pass|secret|key|token|credential")) | .NAME' "$YAML_FILE")
  if [[ -n "$sensitive_vars" ]]; then
    echo "WARNING: Potentially sensitive environment variables detected:"
    echo "$sensitive_vars"
    echo
    echo "These variables may contain sensitive information and should be handled securely."
  else
    echo "No potentially sensitive environment variables detected."
  fi
  echo
  
  read -p "Press Enter to continue..."
  display_menu
}

# Change configuration file
change_config_file() {
  clear
  echo "=== CHANGE CONFIGURATION FILE ==="
  echo
  echo "Current configuration file: $YAML_FILE"
  echo
  read -p "Enter new configuration file path: " new_file
  
  if [[ -f "$new_file" ]]; then
    YAML_FILE="$new_file"
    echo "Configuration file changed successfully!"
  else
    echo "Error: File not found!"
  fi
  
  sleep 2
  display_menu
}

# Main script execution - start with the menu
clear
echo "=== ADVANCED YAML CONFIGURATION ANALYZER ==="
echo "Version 1.0"
echo
echo "Initializing..."
sleep 1

if [[ ! -f "$YAML_FILE" ]]; then
  echo "Error: Default configuration file not found!"
  read -p "Enter configuration file path: " YAML_FILE
  
  if [[ ! -f "$YAML_FILE" ]]; then
    echo "Error: Invalid configuration file. Exiting."
    exit 1
  fi
fi

display_menu