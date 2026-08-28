# Directory structure

```text
/app/
|-- backend/
|   `-- docker-compose.yml                 # Existing application services
|-- frontend/                              # Existing frontend deployment
`-- tools/
    |-- redis.yml                          # Redis Compose model
    |-- redis-entrypoint.sh                # Loads the Redis password secret
    |-- portainer.yml                      # Portainer Compose model
    |-- monitoring.yml                     # Prometheus and exporters
    |-- grafana.yml                        # Grafana Compose fragment
    |-- prometheus.yml                     # Prometheus scrape configuration
    |-- grafana-datasource.yml              # Automatic Grafana data source
    |-- tools.env                          # VM address configuration template
    |-- grafana_admin_password              # Create on VM; do not commit
    |-- redis_password                      # Create on VM; do not commit
    `-- .env                                # Copy of tools.env on the VM
```

`monitoring.yml` and `grafana.yml` form one Compose project
and must be supplied together in the same `docker compose` command.

Published host ports are restricted to the requested range:

| Service | Host port | Container port | Exposure |
|---|---:|---:|---|
| Redis (TCP) | 7003 | 6379 | `192.168.3.52:7003` |
| Portainer HTTPS | 7000 | 9443 | `https://192.168.3.52:7000` |
| Prometheus | 7001 | 9090 | `http://192.168.3.52:7001` |
| Grafana | 7002 | 3000 | `http://192.168.3.52:7002` |
| Node Exporter | None | 9100 | Internal Docker network only |
| cAdvisor | None | 8080 | Internal Docker network only |

The internal container ports do not consume or expose VM ports. Prometheus
reaches those services over `monitoring_network`.

`/app/tools` is a Linux filesystem directory, not a URL path. The files inside
it are accessed through SSH, while the applications are accessed through the
three URLs listed above. Redis is accessed using its TCP endpoint, not a web
URL. A URL such as `http://192.168.3.52/tools` will not work
unless a separate web server or reverse-proxy route is configured.
