#!/usr/bin/env bash
sudo apt-get update
sudo apt-get upgrade -y

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

sudo apt-get install -y openjdk-21-jdk
java --version

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version

curl -fsSL https://get.docker.com | sudo bash
docker --version

sudo usermod -aG docker ai_ado
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker

cd /usr/local/bin
sudo wget https://releases.hashicorp.com/terraform/1.15.7/terraform_1.15.7_linux_amd64.zip
sudo unzip -o terraform_1.15.7_linux_amd64.zip &&  sudo rm -f terraform_1.15.7_linux_amd64.zip
terraform version
ll

cd /usr/local/bin
sudo wget https://releases.hashicorp.com/packer/1.15.4/packer_1.15.4_linux_amd64.zip
sudo unzip -o packer_1.15.4_linux_amd64.zip && sudo rm -f packer_1.15.4_linux_amd64.zip
packer version
ll

cd /usr/local/bin
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
tflint --version
sudo systemctl restart vsts.agent.*