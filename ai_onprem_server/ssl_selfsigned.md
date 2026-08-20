### ssl certificate
- Setup DNS for VM Public IP, Get the VM public Ip and create a record on Do daddy with the domain 
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx openssl

# Generate self-signed certificate
sudo openssl req -x509 -nodes -days 730 -newkey rsa:2048 \
    -keyout /etc/ssl/private/api-mmh-development.inlogictech.com.key \
    -out /etc/ssl/certs/api-mmh-development.inlogictech.com.crt \
    -subj "/CN=api-mmh-development.inlogictech.com"


# Copy existing config as template
sudo cp /etc/nginx/sites-available/ai-inlogic /etc/nginx/sites-available/api-mmh-development.inlogictech.com

# Edit the configuration
sudo nano /etc/nginx/sites-available/api-mmh-development.inlogictech.com

# Create symbolic link
sudo ln -s /etc/nginx/sites-available/api-mmh-development.inlogictech.com /etc/nginx/sites-enabled/

# Optional: Remove default site if exists
sudo rm /etc/nginx/sites-enabled/default
# Test configuration
sudo nginx -t

# If test passes, reload
sudo systemctl reload nginx

# Check status
sudo systemctl status nginx
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw status
# Test HTTP redirects to HTTPS
curl -I http://api-mmh-development.inlogictech.com

# Test HTTPS (ignore certificate warning for self-signed)
curl -k https://api-mmh-development.inlogictech.com/health

# Should return: Healthy

dig @8.8.8.8 api-mmh-development.inlogictech.com A +short
# Should show: 192.168.3.65
0 3 * * 0 systemctl reload nginx


---
# Create a directory for custom DNS configs
sudo mkdir -p /etc/systemd/resolved.conf.d/

# Create a configuration file
sudo nano /etc/systemd/resolved.conf.d/inlogictech.conf
[Resolve]
DNS=8.8.8.8
DNS=1.1.1.1
Domains=~inlogictech.com


sudo systemctl restart systemd-resolved
resolvectl query api-mmh-development.inlogictech.com
curl -ik "https://api-mmh-development.inlogictech.com/databaseService/api/health"
   