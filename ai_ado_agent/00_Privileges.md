## check the privileges
```sh
whoami
groups
id
sudo -l
getent group sudo
grep "^testing:" /etc/passwd
```
- Group Memberships
    - testing – Primary user group.
    - adm – Can read many system log files (e.g., /var/log).
    - cdrom – Access to optical drives.
    - sudo – Administrative privileges using sudo.
    - dip – Dial-up/network device access (legacy; often unused).
    - plugdev – Access to removable devices.
    - users – General users group.
    - lxd – Can manage LXD containers. Membership in this group is effectively privileged because it can be used to gain root access if LXD is configured.
## Rename the user
0. create a temp sudo user than
1. login to temp user and rename the testing to ai_ado
2. logout from temp user and check the login ai_ado user
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
ssh tempadmin@192.168.0.162
password:
whoami
```
- Step 2: Rename testing to ai_ado and update password
```sh
sudo usermod -l ai_ado testing # login name
sudo groupmod -n ai_ado testing # primary group 
sudo usermod -d /home/ai_ado -m ai_ado # home directory
getent passwd ai_ado # verify
ls -ld /home/ai_ado # Check the home directory
#  Update the Password
sudo passwd ai_ado
exit
```
# Step 3: Log in as ai_ado
```sh
ssh ai_ado@192.168.0.162
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