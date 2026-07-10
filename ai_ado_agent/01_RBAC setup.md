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
```
4. Assign Users to Groups
```sh
sudo usermod -aG managers sundar
sudo usermod -aG developers soumyadeep
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
cd /home/ai_ado
touch /opt/test.txt
apt update
systemctl restart ssh
```