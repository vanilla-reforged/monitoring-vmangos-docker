
## A Docker setup to monitor vmangos-docker with prometheus

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

Prometheus can be accessed on port 9090
cAdvisor can be accessed on port 8080
