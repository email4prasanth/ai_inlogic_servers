### Create an SSH key pair
1. On your local machine (or any Linux system), generate a key pair:
```sh
ssh-keygen -t rsa -b 4096 -C "id_rsa_dev"
```
2. Configure the server
- Log in to your Linux server using your current username/password.
```sh
sudo mkdir -p ~/.ssh
sudo chmod 700 ~/.ssh
```
- Append the contents of  id_rsa.pub to:
```sh
sudo nano ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```
- Open power shell and try to connect using private key
```sh
ssh -i id_rsa_dev adminuser@your-server
```
- It should log in without asking for a password.
### Store the private key in Azure DevOps
- Upload only the private key id_rsa to with name 
```sh
Pipelines
  → Library
    → Secure Files
```
- Never upload the .pub file or expose the private key in a repository.