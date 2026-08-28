# Grafana data sources and queries

Open Grafana at `http://192.168.3.52:7002`.

Both data sources are provisioned automatically:

- Prometheus: `http://prometheus:9090`
- Loki: `http://loki:3100`

These are internal Docker addresses. Browser access to Prometheus uses
`http://192.168.3.52:7001`.

Check the available Prometheus metric names at:

`http://192.168.3.52:7001/api/v1/label/__name__/values`

Useful PromQL queries:

```promql
count by (job, instance, server) (container_last_seen)
container_last_seen{server="ccd"}
container_last_seen{server="mcp"}
container_last_seen{server="langfuse"}
```

Useful Loki queries in Grafana Explore:

```logql
{server="ccd"}
{server="mcp"}
{server="langfuse"}
```
