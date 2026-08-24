```sh
/app/
├── backend/
│   └── docker-compose.yml          # Your backend services (unchanged)
└── tools/
    ├── prometheus.yml              # Prometheus configuration
    ├── grafana.yml                 # Grafana configuration + compose
    ├── portainer.yml               # Portainer configuration + compose
    └── monitoring.yml              # Main compose that ties everything together
```