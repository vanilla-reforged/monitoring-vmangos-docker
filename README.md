# Monitoring VMaNGOS with Docker

This repository contains a Docker-based setup for monitoring the VMaNGOS environment.

## Prerequisites

- **Docker**
- **Docker Compose 2.x**

Ensure Docker and Docker Compose are installed and up-to-date on your system before proceeding.

## Security Considerations

To secure your system, it's recommended to configure firewall rules with UFW. For more details, refer to the [ufw-docker guide](https://github.com/chaifeng/ufw-docker).

### Essential UFW Commands

- **Allow management access from a specific IP**:
    ```sh
    ufw allow from [your-client-ip]
    ufw route allow proto tcp from [your-client-ip] to any
    ```

- **Allow public access to specific ports**:
    ```sh
    ufw route allow proto tcp from any to any port [Port]
    ```

Make sure to replace `[your-client-ip]` and `[Port]` with your actual IP address and desired port number.

## Setup Instructions

### Step 1: Clone the Repository

Clone this repository to your local environment:

    ```sh
    git clone https://github.com/vanilla-reforged/monitoring-vmangos-docker
    cd monitoring-vmangos-docker
    ```

### Step 2: Prepare the Environment

Run the initial setup scripts:

    ```sh
    ./scripts/01-docker-daemon-metrics-expose.sh
    ./scripts/02-grafana-directory-permissions-set.sh
    ```

### Step 3: Configure Alerts

Set up your Discord webhook for notifications:

1. Open `alertmanager.yml`.
2. Replace `DISCORD_WEBHOOK` with your actual Discord webhook URL.

### Step 4: Start the Monitoring Stack

Start your monitoring environment using Docker Compose:

    ```sh
    docker compose up -d
    ```

### Step 5: Suggested Grafana Dashboard

For a comprehensive overview of your Docker environment, we recommend using this Grafana dashboard:

- [Raspberry Pi Docker Monitoring Dashboard](https://grafana.com/grafana/dashboards/15120-raspberry-pi-docker-monitoring/)

## Access the Monitoring Tools

Once the stack is running, you can access the following tools:

- **cAdvisor**: `http://[your-ip]:8080`
- **Grafana**: `http://[your-ip]:3030`
- **Prometheus**: `http://[your-ip]:9090`

Be sure to replace `[your-ip]` with your server’s actual IP address.

## Additional Resources

- [Vanilla Reforged Website](https://vanillareforged.org/)
- [Vanilla Reforged Discord](https://discord.gg/KkkDV5zmPb)
- [Vanilla Reforged Patreon](https://www.patreon.com/vanillareforged)
