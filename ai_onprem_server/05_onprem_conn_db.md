- open server, get the public ip
```sh
curl -4 ifconfig.me # 121.244.114.98
# Test the network connection
telnet development-inlogicai-psqlserver-public.postgres.database.azure.com 5432
```
### Add the Firewall Rule
- open **development-inlogicai-psqlserver-public**
- In the left menu, click Networking under Settings
- Under the Public access tab, click + Add firewall rule
- Fill in:
    - Rule name: Allow-OnPrem-Server (or any descriptive name)
    - Start IP: 121.244.114.98
    - End IP: 121.244.114.98
- Click Save
- Wait 1-2 minutes for the rule to propagate
- Test the network connection
```sh
telnet development-inlogicai-psqlserver-public.postgres.database.azure.com 5432
```
- Check if Port 5432 is Blocked Locally
```sh
# Check if there's a local firewall blocking outbound connections
sudo iptables -L -n | grep 5432
# or if using firewalld
sudo firewall-cmd --list-all
```
## Solution-1
- This creates a private endpoint in your Azure VNet:
- Go to your PostgreSQL server in Azure Portal
- Under Networking > Private endpoints > + Create private endpoint
- Follow the wizard
- Then from your on-prem server, you'd need:
    - Site-to-Site VPN or ExpressRoute to your Azure VNet
    - OR use Azure Bastion as a jump host
## solution-2
- Request your network team to allow outbound traffic on port 5432 (TCP) from your server's subnet (192.168.0.0/24) to 20.41.217.198. This is the simplest if they can do it.
```sh
# public ip
curl -4 ifconfig.me
# get private ip, subnetmask
ip addr

Private IP: 192.168.0.140
Subnet Mask: /22 (which equals 255.255.255.252)
Subnet: 192.168.0.0/22 (this covers IPs from 192.168.0.0 to 192.168.3.255)
Broadcast Address: 192.168.3.255