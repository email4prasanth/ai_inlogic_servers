- check the exisiting shared network, path 
```sh
docker network ls
docker network ls | grep shared_network
# else
docker network create shared_network
docker ps
```
#  Start Portainer (Management UI)
```sh
sudo mkdir /app/tools

cd /app/tools
docker-compose -f portainer.yml up -d
```
- Access Portainer at: http://localhost:7000
# Start the monitoring stack (Prometheus + exporters)
```sh
cd /app/tools
docker-compose -f monitoring.yml up -d
```
- Access Prometheus at: http://localhost:7001
# Start Grafana
```sh
cd /app/tools
docker-compose -f grafana.yml up -d
```
- Access Grafana at: http://localhost:7002
- Login: admin/admin
- Node Exporter	http://localhost:7003/metrics	7003
- cAdvisor	http://localhost:7004/metrics	7004


🔧 Configuring Grafana
Add Prometheus as Data Source:
Login to Grafana (http://localhost:3000)

Click Configuration (gear icon) → Data Sources

Click Add data source → Select Prometheus

Set URL to: http://prometheus:9090

Click Save & Test

Import Pre-built Dashboards:
In Grafana, click + → Import

Enter Dashboard IDs:

Node Exporter: 1860 (for host metrics)

cAdvisor: 14282 (for container metrics)

Select your Prometheus data source

Click Import

```sh

Service	New Port	Purpose	URL
Portainer	7000	Docker container management UI	http://localhost:7000
Prometheus	7001	Metrics collection & storage	http://localhost:7001
Grafana	7002	Visualization & dashboards	http://localhost:7002
Node Exporter	7003	Host system metrics	http://localhost:7003/metrics
cAdvisor	7004	Container metrics	http://localhost:7004/metrics
Database Service	6000	Your backend service (unchanged)	http://localhost:6000
```