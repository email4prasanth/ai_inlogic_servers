# Remove the directory
sudo rm -rf /app/tools/redis-entrypoint.sh

# Create the script file
cat > /app/tools/redis-entrypoint.sh << 'EOF'
#!/bin/bash
# Redis entrypoint script
set -e

umask 077
read -rsp 'Redis password: ' REDIS_PASSWORD
printf '%s' "$REDIS_PASSWORD" > redis_password
unset REDIS_PASSWORD

echo "Password saved securely to redis_password"
EOF

# Make it executable
sudo chmod 755 /app/tools/redis-entrypoint.sh
sudo chown adminuser:adminuser /app/tools/redis-entrypoint.sh