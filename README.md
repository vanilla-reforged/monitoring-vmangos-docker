
## A Docker setup to monitor vmangos-docker with prometheus

## Todo

- Use docker swarm to leverage docker secrets.

## Dependencies

- Docker
- Docker compose 2
- p7zip-full
- A POSIX-compliant shell as well as various core utilities (such as `cp` and `rm`) if you intend to use the provided scripts to install, update, and manage VMaNGOS.

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

The assumed client version is `5875` (patch `1.12.1`); if you want to set up VMaNGOS to use a different version, modify the `VMANGOS_CLIENT` entry in the `.env` file accordingly.

The user that is used inside the persistent containers (VMANGOS_DATABASE, VMANGOS_REALMD, VMANGOS_MANGOS) has UID `1000` and GID `1000` by default. You can adjust this if needed; e.g., to match your host UID/GID. This requires editing the entries `VMANGOS_USER_ID` and `VMANGOS_GROUP_ID` in the `.env` file.

Also, please be aware that `./vol/client-data-extracted` gets mounted directly into the mangos server to provide dbc and map data.

### Clone the Repository

```sh
git clone https://github.com/vanilla-reforged/vmangos-docker
```

### Move into the repository and make all scripts executable

```sh
cd vmangos-docker
find ./* -type f -iname "*.sh" -exec chmod +x {} \;
```


### Adjust .env Files

Adjust the .env files for your desired setup:

- `.env` For Docker Compose
- `.env-script` For Scripts
- `.env-vmangos-build` For compiler image build / to set the cmake options.

To make the server public, change the `VMANGOS_REALM_IP` environment variable in the `.env-script` file.

### Generate/Extract Client Data

Copy the contents of your World of Warcraft client directory into `./vol/client-data`. Generating the required data will take many hours. If you have already extracted the client data, place it in `./vol/client-data-extracted` and skip the "03-extract-client-data.sh" script.

### Installation

Install the dependencies, configure and enable a ufw setup that works with docker and limit docker logs with the script:
```sh
./00-setup-dependencies.sh
```

Execute the scripts in order:

```sh
./01-create-dockeruser-and-set-permissions.sh
./02-update-github-and-database.sh
./03-compile-core.sh
./04-extract-client-data.sh
```

Set the ressource limits for the vmangos containers to avoid OOME crashes, the values are adjustable in the script, minimal values are set in the script to ensure the containers start even on shitboxes.

Attention: If Swap Limit Support is not enabled in /etc/default/grub this script will automatically do it and reboot the server to activate it.

```sh
./05-set-ressource-limits.sh
```

Create the vmangos network:

```sh
docker network create vmangos-network
```

Start your environment:

```sh
docker compose up -d
```
