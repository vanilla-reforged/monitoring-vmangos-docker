#!/bin/bash

# This script configures the Docker daemon to expose Prometheus-compatible metrics.

# Set the path for Docker's daemon.json configuration file
CONFIG_FILE="/etc/docker/daemon.json"

# Define the required configuration to enable Prometheus metrics
METRICS_CONFIG='{
  "metrics-addr": "127.0.0.1:9323"
}'

echo "Configuring Docker to expose Prometheus metrics..."

# Check if the configuration file exists
if [ -f "$CONFIG_FILE" ]; then
  echo "Configuration file exists. Checking for existing metrics configuration..."

  # Check if the metrics-addr is already set
  if grep -q '"metrics-addr"' "$CONFIG_FILE"; then
    echo "Metrics address already configured. Skipping modification."
  else
    echo "Adding metrics configuration to the existing file..."
    # Add the metrics-addr configuration while preserving existing settings
    sudo jq '. + {"metrics-addr": "127.0.0.1:9323"}' "$CONFIG_FILE" | sudo tee "$CONFIG_FILE" > /dev/null
  fi
else
  echo "Configuration file does not exist. Creating and adding the configuration..."
  # Create the configuration file with the metrics configuration
  echo "$METRICS_CONFIG" | sudo tee "$CONFIG_FILE" > /dev/null
fi

# Restart Docker to apply the changes
echo "Restarting Docker to apply changes..."
sudo systemctl restart docker

# Check if Docker restarted successfully
if [ $? -eq 0 ]; then
  echo "Docker has been configured successfully to expose Prometheus metrics on 127.0.0.1:9323."
else
  echo "Failed to restart Docker. Please check the Docker service status for errors."
fi
