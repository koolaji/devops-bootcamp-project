#!/bin/bash
#########################################################
# Project Setup Script
#
# This script checks for all necessary command-line tools
# required by the log analysis project.
#
# Usage: ./setup.sh
#########################################################

echo "=============================================="
echo "      Checking Project Dependencies...        "
echo "=============================================="
echo

# Flag to track if all dependencies are met
all_deps_met=true

# --- Dependency 1: jq ---
echo -n "Checking for 'jq'... "
if command -v jq &> /dev/null; then
    echo "✅ Found"
else
    echo "❌ Not Found"
    echo "   'jq' is required for the JSON log analyzer."
    echo "   Please install it:"
    echo "   - Debian/Ubuntu: sudo apt-get update && sudo apt-get install jq"
    echo "   - macOS: brew install jq"
    echo "   - RHEL/CentOS: sudo yum install jq"
    all_deps_met=false
    echo
fi

# --- Dependency 2: yq ---
echo -n "Checking for 'yq'... "
if command -v yq &> /dev/null; then
    echo "✅ Found"
else
    echo "❌ Not Found"
    echo "   'yq' is required for the YAML config analyzer."
    echo "   Please install it:"
    echo "   - Using pip: pip install yq"
    echo "   - macOS: brew install yq"
    echo "   - From GitHub releases for other systems."
    all_deps_met=false
    echo
fi

# --- Final Summary ---
echo "=============================================="
if [ "$all_deps_met" = true ]; then
    echo "✅ All dependencies are met. You are ready to start!"
else
    echo "⚠️ Please install the missing dependencies listed above."
fi
echo "=============================================="
