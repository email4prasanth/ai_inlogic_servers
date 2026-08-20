1. Initial Setup (One-Time)
```sh
# Install required packages
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx openssl

# Obtain Let's Encrypt certificate
sudo certbot --nginx -d api-mmh-development.inlogictech.com

# Configure DNS - ensure api-mmh-development.inlogictech.com points to your VM's public IP
# Then create Nginx config
sudo cp /etc/nginx/sites-available/ai-inlogic /etc/nginx/sites-available/api-mmh-development.inlogictech.com
sudo nano /etc/nginx/sites-available/api-mmh-development.inlogictech.com

# Enable site
sudo ln -s /etc/nginx/sites-available/api-mmh-development.inlogictech.com /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Configure firewall
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw status
```
2. Auto-Renewal with Crontab (Every Sunday at 3 AM)
```sh
# Open crontab
sudo crontab -e

# Add this line (runs every Sunday at 3 AM)
0 3 * * 0 /usr/bin/certbot renew --quiet --post-hook "systemctl reload nginx"
```