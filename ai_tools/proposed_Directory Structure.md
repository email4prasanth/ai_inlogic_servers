# Proposed directory structure

```text
/app/
|-- backend/
|   `-- docker-compose.yml                 # Existing application services
|-- frontend/                              # Existing frontend deployment
`-- tools/
    |-- proposed_portainer.yml             # Portainer Compose model
    |-- proposed_monitoring.yml            # Prometheus and exporters
    |-- proposed_grafana.yml               # Grafana Compose fragment
    |-- proposed_prometheus.yml            # Prometheus scrape configuration
    |-- proposed_grafana-datasource.yml     # Automatic Grafana data source
    |-- proposed_tools.env                  # VM address configuration template
    |-- grafana_admin_password              # Create on VM; do not commit
    `-- .env                                # Copy of proposed_tools.env on the VM
```

`proposed_monitoring.yml` and `proposed_grafana.yml` form one Compose project
and must be supplied together in the same `docker compose` command.

Published host ports are restricted to the requested range:

| Service | Host port | Container port | Exposure |
|---|---:|---:|---|
| Portainer HTTPS | 7000 | 9443 | `https://192.168.3.65:7000` |
| Prometheus | 7001 | 9090 | `http://192.168.3.65:7001` |
| Grafana | 7002 | 3000 | `http://192.168.3.65:7002` |
| Node Exporter | None | 9100 | Internal Docker network only |
| cAdvisor | None | 8080 | Internal Docker network only |

The internal container ports do not consume or expose VM ports. Prometheus
reaches those services over `monitoring_network`.

`/app/tools` is a Linux filesystem directory, not a URL path. The files inside
it are accessed through SSH, while the applications are accessed through the
three URLs listed above. A URL such as `http://192.168.3.65/tools` will not work
unless a separate web server or reverse-proxy route is configured.
