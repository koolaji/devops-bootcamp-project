#!/bin/bash
#########################################################
# Docker Project Setup Script
#
# This script checks for necessary Docker and Docker Compose
# installations required by the Docker module.
#
# Usage: ./setup.sh
#########################################################

echo "=============================================="
echo "      Checking Docker Project Dependencies...   "
echo "=============================================="
echo

all_deps_met=true

# --- Dependency 1: Docker ---
echo -n "Checking for 'docker'... "
if command -v docker &> /dev/null; then
    echo "✅ Found"
else
    echo "❌ Not Found"
    echo "   Docker is required for all Docker tasks."
    echo "   Please install it: https://docs.docker.com/get-docker/"
    all_deps_met=false
    echo
fi

# --- Dependency 2: Docker Compose ---
echo -n "Checking for 'docker-compose'... "
if command -v docker-compose &> /dev/null; then
    echo "✅ Found"
else
    echo "❌ Not Found"
    echo "   Docker Compose is required for multi-service applications."
    echo "   Please install it: https://docs.docker.com/compose/install/"
    all_deps_met=false
    echo
fi

# --- Final Summary ---
echo "=============================================="
if [ "$all_deps_met" = true ]; then
    echo "✅ All Docker dependencies are met. You are ready to start!"
else
    echo "⚠️ Please install the missing dependencies listed above."
fi
echo "=============================================="
