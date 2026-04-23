# Monitoring VMaNGOS with Docker

This repository contains a Docker-based setup for monitoring the VMaNGOS environment.

## Prerequisites

- **Docker**
- **Docker Compose 2.x**

Ensure Docker and Docker Compose are installed and up-to-date on your system before proceeding.

## Security Considerations

### Using Tailscale

[Tailscale](https://tailscale.com/)

### Secure Container Access with Tailscale

When using Tailscale, be aware that any port you bind to a container will bypass UFW without the modifcation below and become exposed to the public internet.

Only expose ports that require internet access.

For example, you can keep your endpoints private and access it securely over Tailscale:

    sudo tailscale serve --tcp 8090 tcp://127.0.0.1:8090

To enable SSH access via Tailscale:

    sudo tailscale up --ssh

### Using UFW

- **Allow management access from a specific IP**:
    ```sh
    ufw allow from [your-client-ip] to any
    ufw route allow proto tcp from [your-client-ip] to any
    ```

- **Allow public access to specific ports**:
    ```sh
    ufw route allow proto tcp from any to any port [Port]
    ```

Make sure to replace `[your-client-ip]` and `[Port]` with your actual IP address and desired port number.

## Setup Instructions

### Step 1: Clone the Repository

Use a User with UID:GUID 1000:1000 for this step (default user on ubuntu).:

    git clone https://github.com/vanilla-reforged/monitoring-vmangos-docker
    cd monitoring-vmangos-docker

### Step 2: Prepare the Environment

Run the initial setup scripts:

    ./01-docker-daemon-metrics-expose.sh
    ./02-grafana-directory-permissions-set.sh

### Step 3: Configure Alerts

Set up your Discord webhook for notifications:

1. Open `alertmanager.yml`.
2. Replace `DISCORD_WEBHOOK` with your actual Discord webhook URL.

### Step 4: Start the Monitoring Stack

Start your monitoring environment using Docker Compose:

    sudo docker compose up -d

### Step 5: Suggested Grafana Dashboard

For a comprehensive overview of your Docker environment, we recommend using this Grafana dashboard:

- [Raspberry Pi Docker Monitoring Dashboard](https://grafana.com/grafana/dashboards/15120-raspberry-pi-docker-monitoring/)

## Access the Monitoring Tools

Once the stack is running, you can access the different tools by using:

`prometheus [your-ip]:9090`
`cadvisor [your-ip]:8080`
`node_exporte [your-ip]:9100`
`alertmanager [your-ip]:9093`
`grafana [your-ip]:3000`

Be sure to replace `[your-ip]` with your server’s actual IP address.

## Additional Resources

- [Vanilla Reforged Website](https://vanillareforged.org/)
- [Vanilla Reforged Discord](https://discord.gg/KkkDV5zmPb)

## My Links

- [My Patreon](https://www.patreon.com/flyingfrog23)
- [Buy Me a Coffee](https://buymeacoffee.com/flyingfrog23)
