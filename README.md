
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

### Public Access:

```sh
ufw route allow proto tcp from any to any port [Port]
ufw route allow proto tcp from any to any port [Port]
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

### Setup

Discord Webhook:

Replace "DISCORD_WEBHOOK" with your personal discord webhook in
```sh
alertmanager.yml
```

Suggested Grafana Dashboard:

```sh
https://grafana.com/grafana/dashboards/15120-raspberry-pi-docker-monitoring/
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
