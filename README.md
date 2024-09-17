
## A Docker setup to monitor vmangos-docker

## Dependencies

- Docker
- Docker compose 2

## Security

Secure your system by understanding the following information: [ufw-docker](https://github.com/chaifeng/ufw-docker).

The ufw commands you will need to secure your installation:

### Management:

```sh
ufw allow from [your client ip]
ufw route allow proto tcp from [your client ip] to any
```

### Vmangos public access:

```sh
ufw route allow proto tcp from any to any port 3724
ufw route allow proto tcp from any to any port 8085
```

## Docker Setup

### Clone the Repository

```sh
git clone https://github.com/vanilla-reforged/monitoring-vmangos-docker/
```

### Move into the repository and make all scripts executable

```sh
cd monitoring-vmangos-docker
```

### Installation

Start your environment:

```sh
docker compose up -d
```

### Access

cAdvisor:
```sh
http://[yourip]:8080
```
Grafana:
```sh
http://[yourip]:3030
```
Prometheus:
```sh
http://[yourip]:9090
```
Grafana Dashboard:
```sh
https://grafana.com/grafana/dashboards/15120-raspberry-pi-docker-monitoring/
```
How to integrate Grafana with Discord:
```sh
https://grafana.com/docs/grafana/latest/alerting/configure-notifications/manage-contact-points/integrations/configure-discord/
```

Input your webhook in alertmanager.yml to receive discord notifications.

Schedule the daily alert tab with cron

crontab -e

0 6 * * * /path/to/your/01-daily-alert-test.sh

