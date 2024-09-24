#!/bin/bash

# Define the path to the Docker daemon configuration file
CONFIG_FILE="/etc/docker/daemon.json"

# Define the new configuration to add as an associative array
NEW_CONFIG='{"metrics-addr": "127.0.0.1:9323", "experimental": true}'

# Install jq if it is not already installed
echo "Checking if jq is installed..."
if ! command -v jq &> /dev/null; then
  echo "jq is not installed. Installing jq..."
  if [[ -f /etc/debian_version ]]; then
    sudo apt-get update
    sudo apt-get install -y jq
  elif [[ -f /etc/redhat-release ]]; then
    sudo yum install -y epel-release
    sudo yum install -y jq
  elif [[ -f /etc/fedora-release ]]; then
    sudo dnf install -y jq
  else
    echo "Unsupported OS. Please install jq manually."
    exit 1
  fi
else
  echo "jq is already installed."
fi

# Backup the existing configuration file if it exists
if [ -f "$CONFIG_FILE" ]; then
  echo "Backing up the existing configuration file..."
  sudo cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
fi

# Check if the configuration file exists and is not empty
if [ -s "$CONFIG_FILE" ]; then
  echo "Configuration file exists. Merging new settings with existing ones..."
  
  # Safely merge the existing configuration with the new configuration using a temporary file
  sudo jq --argjson newConfig "$NEW_CONFIG" '. * $newConfig' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp"
  
  # Check if the merge was successful and if the temp file is valid JSON
  if jq empty "${CONFIG_FILE}.tmp" &> /dev/null; then
    sudo mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    echo "Configuration successfully merged."
  else
    echo "Error merging configurations. Restoring from backup..."
    sudo mv "${CONFIG_FILE}.backup" "$CONFIG_FILE"
    exit 1
  fi
else
  echo "Configuration file does not exist or is empty. Creating a new one with the specified settings..."
  
  # Create a new configuration file with the new settings
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
  # Restore from backup if Docker restart fails
  if [ -f "${CONFIG_FILE}.backup" ]; then
    echo "Restoring the original configuration..."
    sudo mv "${CONFIG_FILE}.backup" "$CONFIG_FILE"
    sudo systemctl restart docker
  fi
fi
