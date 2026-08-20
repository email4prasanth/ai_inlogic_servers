-  install and start Nginx 
```sh
cd
sudo apt update
sudo apt install nginx -y
sudo systemctl status nginx
sudo ufw allow 'Nginx Full'
sudo ufw reload
sudo ufw status
nginx -v
sudo ss -tulpn | grep :80
```
- Verify Nginx is running- Go to your EC2 instance’s public IPv4 address in a browser
```sh
http://<your-ec2-public-ip>
```
- Useful service management commands
```sh
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo systemctl stop nginx
```
- create your own Nginx site configuration
```sh
sudo vi /etc/nginx/sites-available/mcp-mmh-development.inlogictech.com # use 03_b_nginx_file.md
sudo unlink /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/mcp-mmh-development.inlogictech.com /etc/nginx/sites-enabled/
sudo nginx -t # test the config first to avoid errors
sudo systemctl reload nginx
sudo systemctl status nginx
sudo systemctl restart nginx
sudo nginx -T | grep server_name
```