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
    |-- remote-tools.yml                   # Deploy on CCD, MCP, and Langfuse VMs
    |-- remote-tools.env                   # Remote VM environment template
    |-- alloy-config.alloy                 # Remote Docker log collection
    |-- monitoring.yml                     # Prometheus and exporters
    |-- logging.yml                        # Central Loki service
    |-- grafana.yml                        # Grafana Compose fragment
    |-- prometheus.yml                     # Prometheus scrape configuration
    |-- loki.yml                           # Loki storage and retention configuration
    |-- grafana-datasource.yml              # Automatic Grafana data source
    |-- grafana-loki-datasource.yml         # Automatic Loki data source
    |-- tools.env                          # VM address configuration template
    |-- grafana_admin_password              # Create on VM; do not commit
    |-- portainer_admin_password            # Create on VM; do not commit
    |-- redis_password                      # Create on VM; do not commit
    `-- .env                                # Copy of tools.env on the VM
```

`monitoring.yml`, `logging.yml`, and `grafana.yml` form one Compose project and
must be supplied together in the same `docker compose` command.

Published host ports are restricted to the requested range:

| Service | Host port | Container port | Exposure |
|---|---:|---:|---|
| Redis (TCP) | 7003 | 6379 | `192.168.3.52:7003` |
| Portainer HTTPS | 7000 | 9443 | `https://192.168.3.52:7000` |
| Prometheus | 7001 | 9090 | `http://192.168.3.52:7001` |
| Grafana | 7002 | 3000 | `http://192.168.3.52:7002` |
| Loki API | 7004 | 3100 | Alloy ingestion from `.53`-`.55` |
| Node Exporter | None | 9100 | Internal Docker network only |
| cAdvisor | None | 8080 | Internal Docker network only |

Install the following bundle in `/app/remote-tools` on each application VM:

```text
/app/remote-tools/
|-- remote-tools.yml
|-- remote-tools.env
|-- alloy-config.alloy
`-- .env
```

The remote VMs can reuse the same ports because each has its own IP address:

| VM | Role | Node Exporter | cAdvisor | Portainer Agent |
|---|---|---:|---:|---:|
| `192.168.3.53` | CCD | 7100 | 7101 | 9001 |
| `192.168.3.54` | MCP | 7100 | 7101 | 9001 |
| `192.168.3.55` | Langfuse | 7100 | 7101 | 9001 |

Prometheus reaches local exporters over `monitoring_network` and remote
exporters through their private VM addresses. Alloy on each remote VM pushes
Docker logs to `192.168.3.52:7004`.

`/app/tools` is a Linux filesystem directory, not a URL path. The files inside
it are accessed through SSH, while the applications are accessed through the
URLs listed above. Redis is accessed using its TCP endpoint, not a web
URL. A URL such as `http://192.168.3.52/tools` will not work
unless a separate web server or reverse-proxy route is configured.
