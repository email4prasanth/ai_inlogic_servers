#!/usr/bin/env bash
sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y \
        unzip \
        jq \
        curl \
        wget \
        git \
        net-tools \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release


# Install Azure CLI and Login if it is Ubuntu 24.04 LTS
dpkg -l ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version

# If it is Ubuntu 26.04 LTS
# Run the commands
curl -I http://archive.ubuntu.com/ubuntu/dists/resolute/InRelease
curl -I http://security.ubuntu.com/ubuntu/dists/resolute-security/InRelease

sudo nano /etc/apt/sources.list.d/ubuntu.sources
# Replace:
URIs: http://in.archive.ubuntu.com/ubuntu/
# with
URIs: https://archive.ubuntu.com/ubuntu/
# Replace:
URIs: http://security.ubuntu.com/ubuntu/
# with
URIs: https://security.ubuntu.com/ubuntu/
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt update
sudo apt upgrade -y
sudo reboot
dpkg -l ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version

# Login to Azure Container Registry (ACR) 
az account show
az acr login --name **name** ## should login via cicd not manually

# Install docker
curl -fsSL https://get.docker.com | sudo bash
docker --version

sudo usermod -aG docker adminuser
getent group docker
exit
docker ps
docker images
docker version
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker

# Create Docker Shared Network for Service Communication 
## Check the network
- If not exists, Create Docker Shared Network for Service Communication
```sh
docker network create shared_network
```
- Set Up database_service
```sh
sudo mkdir -p /app/backend && cd /app/backend/
ls -al
sudo chmod -R 755 /app/backend/
sudo chown adminuser:adminuser /app/backend/
touch .env.databaseservice
nano docker-compose.yml
```
- setup frontend
```sh
sudo mkdir -p /app/frontend && cd /app/frontend/
ls -al
sudo chmod -R 755 /app/frontend/
sudo chown adminuser:adminuser /app/frontend/
touch .env.frontend
nano docker-compose.yml
```