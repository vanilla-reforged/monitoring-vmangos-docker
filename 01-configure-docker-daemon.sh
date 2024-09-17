#!/bin/bash

# Define the path to the Docker daemon configuration file
CONFIG_FILE="/etc/docker/daemon.json"

# Define the new configuration to add
NEW_CONFIG='{
  "metrics-addr": "127.0.0.1:9323",
  "experimental": true
}'

# Install jq if it is not already installed
echo "Checking if jq is installed..."
if ! command -v jq &> /dev/null; then
  echo "jq is not installed. Installing jq..."
  # Check for Debian/Ubuntu and install jq
  if [[ $(uname -a) == *"Debian"* || $(uname -a) == *"Ubuntu"* ]]; then
    sudo apt-get update
    sudo apt-get install -y jq
  # Check for CentOS/RHEL and install jq
  elif [[ -f /etc/redhat-release ]]; then
    sudo yum install -y epel-release
    sudo yum install -y jq
  # Check for Fedora and install jq
  elif [[ -f /etc/fedora-release ]]; then
    sudo dnf install -y jq
  else
    echo "Unsupported OS. Please install jq manually."
    exit 1
  fi
else
  echo "jq is already installed."
fi

# Check if the configuration file exists
if [ -f "$CONFIG_FILE" ]; then
  echo "Configuration file exists. Merging new settings with existing ones..."
  
  # Merge the existing configuration with the new configuration
  sudo jq --argjson newConfig "$NEW_CONFIG" '. * $newConfig' "$CONFIG_FILE" | sudo tee "$CONFIG_FILE" > /dev/null
else
  echo "Configuration file does not exist. Creating a new one with the specified settings..."
  
  # Create the configuration file with the new settings
  echo "$NEW_CONFIG" | sudo tee "$CONFIG_FILE" > /dev/null
fi

# Restart Docker to apply changes
echo "Restarting Docker to apply changes..."
sudo systemctl restart docker

# Check if Docker restarted successfully
if [ $? -eq 0 ]; then
  echo "Docker configuration updated successfully. Docker is now exposing metrics on 127.0.0.1:9323."
else
  echo "Failed to restart Docker. Please check the Docker service status for errors."
fi
