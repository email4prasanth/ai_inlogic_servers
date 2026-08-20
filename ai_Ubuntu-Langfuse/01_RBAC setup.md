## RBAC setup with three roles: Manager, Developer, and QA
1. Typical Permission Matrix
| Activity                    | Manager | Developer |  QA |
| --------------------------- | :-----: | :-------: | :-: |
| SSH Login                   |    ✅    |     ✅     |  ✅  |
| Access Home Directory       |    ✅    |     ✅     |  ✅  |
| Read Application Files      |    ✅    |     ✅     |  ✅  |
| Modify Application Files    |    ❌    |     ✅     |  ❌  |
| Deploy Applications         |    ✅    |     ❌     |  ❌  |
| View Application Logs       |    ✅    |     ✅     |  ✅  |
| Restart Application Service |    ✅    |     ❌     |  ❌  |
| Install Packages            |    ❌    |     ❌     |  ❌  |
| Full `sudo` Access          |    ❌    |     ❌     |  ❌  |

2. Create Groups
```sh
sudo groupadd managers
sudo groupadd developers
sudo groupadd qa
# verify
getent group managers
getent group developers
getent group qa
```
3. Create Users (if they do not already exist)
```sh
sudo adduser sundar
sudo adduser soumyadeep
sudo adduser rishav
sudo adduser kavya
sudo adduser ganesh
sudo adduser saran
sudo adduser sharmili
```
4. Assign Users to Groups
```sh
sudo usermod -aG managers sundar
sudo usermod -aG developers soumyadeep
sudo usermod -aG developers rishav
sudo usermod -aG developers kavya
sudo usermod -aG developers ganesh
sudo usermod -aG developers saran
sudo usermod -aG developers sharmili
```
5. view the group members
```sh
getent group managers
getent group developers
getent group qa
```
## test manager privilages
```sh
whoami
id
groups
sudo -l
pwd
touch test.txt
ls -l
# permission denied items
cd /home/ai_dev_inlogic_be
touch /opt/test.txt
apt update
systemctl restart ssh
```
- to give docker logs
```sh
# 3. Add users to docker group as well (for Docker access)
sudo usermod -aG docker soumyadeep
sudo usermod -aG docker rishav
sudo usermod -aG docker kavya
sudo usermod -aG docker ganesh
sudo usermod -aG docker saran
sudo usermod -aG docker sharmili

# 4. Verify group memberships
groups soumyadeep
groups rishav
groups kavya
groups ganesh
groups saran
groupss sharmili
```
- Configure Sudoers for developers Group
```sh
sudo visudo -f /etc/sudoers.d/developers

# Allow developers to run Docker commands without password
%developers ALL=(ALL) NOPASSWD: /usr/bin/docker
# or
# Allow developers to run specific Docker commands without password
%developers ALL=(ALL) NOPASSWD: /usr/bin/docker ps, /usr/bin/docker logs, /usr/bin/docker inspect, /usr/bin/docker stats, /usr/bin/docker restart, /usr/bin/docker stop, /usr/bin/docker start

# Add the rule directly
echo '%developers ALL=(ALL) NOPASSWD: /usr/bin/docker' | sudo tee /etc/sudoers.d/developers
```
- cross check
```sh
# View the file
sudo cat /etc/sudoers.d/developers

# Check permissions (should be -r--r----- or -r--r--r--)
ls -al /etc/sudoers.d/developers

# Validate sudoers syntax
sudo visudo -c
```