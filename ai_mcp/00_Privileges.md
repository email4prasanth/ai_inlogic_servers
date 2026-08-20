## check the privileges
```sh
whoami
groups
id
sudo -l
getent group sudo
grep "^mcps_ai:" /etc/passwd
```
- Group Memberships
    - mcps_ai – Primary user group.
    - adm – Can read many system log files (e.g., /var/log).
    - cdrom – Access to optical drives.
    - sudo – Administrative privileges using sudo.
    - dip – Dial-up/network device access (legacy; often unused).
    - plugdev – Access to removable devices.
    - users – General users group.
    - lxd – Can manage LXD containers. Membership in this group is effectively privileged because it can be used to gain root access if LXD is configured.
## Rename the user
0. create a temp sudo user than
1. login to temp user and rename the admin_ai to adminuser
2. logout from temp user and check the login adminuser user
3. delete the temp sudo user
```sh
sudo adduser tempadmin
cat /etc/passwd
sudo usermod -aG sudo tempadmin
sudo -l -U tempadmin
exit
```
- Step 1: Log in as the Temporary User
```sh
ssh tempadmin@192.168.3.62
password:
whoami
```
- Step 2: Rename mcps_ai to adminuser and update password
```sh
sudo loginctl terminate-user mcps_ai
sudo usermod -l adminuser mcps_ai # login name
sudo groupmod -n adminuser mcps_ai # primary group 
sudo usermod -d /home/adminuser -m adminuser # home directory
getent passwd adminuser # verify
ls -ld /home/adminuser # Check the home directory
#  Update the Password
sudo passwd adminuser
exit
```
# Step 3: Log in as adminuser
```sh
ssh adminuser@192.168.3.62
password:
whoami
id
groups
sudo -l
```
# step 4: Delete the Temporary User
```sh
sudo deluser tempadmin
sudo deluser --remove-home tempadmin
id tempadmin
```