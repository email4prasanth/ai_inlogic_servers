```sh
# Check CPU frequency and throttling
lscpu
# Memory Usage
free -h
# Storage Usage 
df -h
echo "=== CPU ===" && mpstat 1 1 | grep "Average" && \
echo "=== MEMORY ===" && free -h && \
echo "=== DISK ===" && df -h / && \
echo "=== TOP PROCESSES ===" && ps aux --sort=-%cpu | head -6
```