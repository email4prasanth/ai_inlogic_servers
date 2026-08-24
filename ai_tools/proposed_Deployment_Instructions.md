# Proposed deployment instructions

## 1. Create the tools directory

Give `adminuser` ownership so deployment does not require running Compose as
root. Docker group membership is still required to use Docker without `sudo`.

```bash
sudo install -d -m 0755 -o adminuser -g adminuser /app/tools
cd /app/tools
```

Copy all proposed files from this directory into `/app/tools`, including
`proposed_tools.env`.

## 2. Confirm network and application connectivity

The `shared_network` already exists. Confirm that `database_service` is also
attached to it:

```bash
docker network inspect shared_network
docker inspect database_service --format '{{json .NetworkSettings.Networks}}'
curl -fsS http://192.168.3.65:6000/metrics | head
```

If `shared_network` is absent from the inspection output, add it as an external
network in `/app/backend/docker-compose.yml` and recreate `database_service`.

## 3. Configure the VM address

The VM's current private IP address is `192.168.3.65`. Install the proposed
environment file as `.env`; Docker Compose reads this file automatically:

```bash
cd /app/tools
cp proposed_tools.env .env
chmod 600 .env
```

The resulting values bind the published ports specifically to `192.168.3.65`
and configure Grafana's generated URLs for `http://192.168.3.65:7002`. If the
VM IP changes, update both values in `.env` before recreating the containers.

Do not change `TOOLS_BIND_ADDRESS` to `0.0.0.0` unless Azure NSG and host
firewall rules restrict access to trusted administrator addresses.

## 4. Create the Grafana admin password secret

```bash
cd /app/tools
umask 077
read -rsp 'Grafana admin password: ' GRAFANA_PASSWORD
printf '%s' "$GRAFANA_PASSWORD" > grafana_admin_password
unset GRAFANA_PASSWORD
echo
```

Do not commit or copy `grafana_admin_password` back into source control.

## 5. Validate the Compose models

Use Compose v2 (`docker compose`). Grafana and monitoring must be validated and
started as one combined model:

```bash
cd /app/tools
docker compose -p portainer -f proposed_portainer.yml config -q
docker compose -p monitoring \
  -f proposed_monitoring.yml \
  -f proposed_grafana.yml config -q
```

## 6. Start Portainer

```bash
docker compose -p portainer -f proposed_portainer.yml pull
docker compose -p portainer -f proposed_portainer.yml up -d
```

Portainer: `https://192.168.3.65:7000`

Portainer uses a self-signed HTTPS certificate by default, so the browser may
show a certificate warning until a trusted reverse proxy/certificate is added.

## 7. Start Prometheus, exporters, and Grafana

```bash
docker compose -p monitoring \
  -f proposed_monitoring.yml \
  -f proposed_grafana.yml pull

docker compose -p monitoring \
  -f proposed_monitoring.yml \
  -f proposed_grafana.yml up -d
```

Prometheus: `http://192.168.3.65:7001`

Grafana: `http://192.168.3.65:7002`

Grafana username: `admin`; use the password stored in
`/app/tools/grafana_admin_password`. The Prometheus data source is provisioned
automatically as `http://prometheus:9090`.

## 8. Verify the deployment

```bash
docker compose -p portainer -f proposed_portainer.yml ps
docker compose -p monitoring \
  -f proposed_monitoring.yml \
  -f proposed_grafana.yml ps

curl -kfsS https://192.168.3.65:7000/api/status
curl -fsS http://192.168.3.65:7001/-/ready
curl -fsS http://192.168.3.65:7002/api/health
curl -fsS http://192.168.3.65:7001/api/v1/targets
```

In Prometheus, open **Status > Target health** and confirm these targets are
`UP`: `prometheus`, `database_service`, `node_exporter`, and `cadvisor`.

## 9. Accessing files versus applications

`/app/tools` is a directory on the VM, not a browser URL. Inspect its files over
SSH:

```bash
ls -al /app/tools
less /app/tools/proposed_Deployment_Instructions.md
```

The browser accesses the running applications through ports `7000` to `7002`.
`http://192.168.3.65/tools` is not configured by this deployment. Supporting a
`/tools/...` URL would require a separate reverse-proxy configuration.

## 10. Optional dashboards

In Grafana, select **Dashboards > New > Import**:

- Node Exporter Full: dashboard ID `1860`
- Choose a maintained cAdvisor dashboard compatible with your cAdvisor metrics

Review imported dashboards before treating them as production configuration.
