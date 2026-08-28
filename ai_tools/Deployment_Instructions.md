# Deployment instructions

## 1. Create the tools directory

Give `adminuser` ownership so deployment does not require running Compose as
root. Docker group membership is still required to use Docker without `sudo`.

```bash
sudo install -d -m 0755 -o adminuser -g adminuser /app/tools
cd /app/tools
```

Copy all files from this directory into `/app/tools`, including `tools.env`.

## 2. Confirm the shared Docker network

Redis joins `shared_network` so other application containers can reach it by
the hostname `redis`. Confirm that the network already exists:

```bash
docker network inspect shared_network
```

If it does not exist, create it before starting Redis:

```bash
docker network create shared_network
```

## 3. Configure the VM address

The VM's current private IP address is `192.168.3.52`. Install the environment
file as `.env`; Docker Compose reads this file automatically:

```bash
cd /app/tools
cp tools.env .env
chmod 600 .env
```

The resulting values bind the published ports specifically to `192.168.3.52`
and configure Grafana's generated URLs for `http://192.168.3.52:7002`. If the
VM IP changes, update both values in `.env` before recreating the containers.

Do not change `TOOLS_BIND_ADDRESS` to `0.0.0.0` unless Azure NSG and host
firewall rules restrict access to trusted addresses.

## 4. Create the password secrets

```bash
cd /app/tools
umask 077
read -rsp 'Grafana admin password: ' GRAFANA_PASSWORD
printf '%s' "$GRAFANA_PASSWORD" > grafana_admin_password
unset GRAFANA_PASSWORD
echo

read -rsp 'Redis password: ' REDIS_PASSWORD
printf '%s' "$REDIS_PASSWORD" > redis_password
unset REDIS_PASSWORD
echo

read -rsp 'New Portainer admin password: ' PORTAINER_PASSWORD
printf '%s' "$PORTAINER_PASSWORD" > portainer_admin_password
unset PORTAINER_PASSWORD
echo

umask 022
chmod 644 /app/tools/monitoring.yml
chmod 644 /app/tools/prometheus.yml
chmod 644 /app/tools/loki.yml
chmod 644 /app/tools/grafana-datasource.yml
chmod 644 /app/tools/grafana-loki-datasource.yml
```

Do not commit or copy `grafana_admin_password`, `redis_password`, or `.env`
back into source control.

## 5. Validate the Compose models

Use Compose v2 (`docker compose`). Grafana, monitoring, and logging must be
validated and started as one combined model:

```bash
cd /app/tools
docker compose -p redis -f redis.yml config -q
echo $? #expect 0 as output
docker compose -p portainer -f portainer.yml config -q
echo $?
docker compose -p monitoring \
  -f monitoring.yml \
  -f logging.yml \
  -f grafana.yml config -q
echo $?
```

## 6. Start Redis

```bash
docker compose -p redis -f redis.yml pull
docker images
docker compose -p redis -f redis.yml up -d
docker ps

# check the connection expect output is PONG
docker compose -p redis -f redis.yml exec redis sh -c \
  'REDISCLI_AUTH="$(cat /run/secrets/redis_password)" redis-cli ping'
```

Application containers attached to `shared_network` can connect to
`redis:6379`. Host clients can connect to `192.168.3.52:7003`. Both must use
the password stored in `/app/tools/redis_password`.

## 7. Start Portainer

```bash
cp tools.env .env
chmod 600 .env
cat .env

docker compose -p portainer -f portainer.yml pull
docker compose -p portainer -f portainer.yml config | grep -A6 'ports:'
docker compose -p portainer -f portainer.yml up -d
docker ps --filter name=portainer
# result 192.168.3.52:7000->9443/tcp
# test
curl -k https://192.168.3.52:7000/api/status
```

Portainer: `https://192.168.3.52:7000`


Portainer uses a self-signed HTTPS certificate by default, so the browser may
show a certificate warning until a trusted reverse proxy or certificate is
added.

## 8. Start Prometheus, exporters, Loki, and Grafana

```bash
docker compose -p monitoring \
  -f monitoring.yml \
  -f logging.yml \
  -f grafana.yml pull

docker compose -p monitoring \
  -f monitoring.yml \
  -f logging.yml \
  -f grafana.yml up -d --force-recreate
```

Prometheus: `http://192.168.3.52:7001`

Grafana: `http://192.168.3.52:7002`

Loki API: `http://192.168.3.52:7004/ready`
or ` http://192.168.3.52:7004/loki/api/v1/labels`

Grafana username: `admin`; use the password stored in
`/app/tools/grafana_admin_password`. The Prometheus data source is provisioned
automatically as `http://prometheus:9090`. The Loki data source is provisioned
automatically as `http://loki:3100`.

## 9. Verify the deployment

```bash
docker compose -p redis -f redis.yml ps
docker compose -p portainer -f portainer.yml ps
docker compose -p monitoring \
  -f monitoring.yml \
  -f logging.yml \
  -f grafana.yml ps

docker compose -p redis -f redis.yml exec redis sh -c \
  'REDISCLI_AUTH="$(cat /run/secrets/redis_password)" redis-cli ping'
curl -kfsS https://192.168.3.52:7000/api/status
curl -fsS http://192.168.3.52:7001/-/ready
curl -fsS http://192.168.3.52:7002/api/health
curl -fsS http://192.168.3.52:7004/ready
curl -fsS http://192.168.3.52:7001/api/v1/targets
```

The Redis command should return `PONG`. In Prometheus, open the target health
page under **Status** and confirm `prometheus`, `node_exporter`, and `cadvisor`
are `UP`. Remote targets are expected to remain `DOWN` until step 10 is
complete.

## 10. Deploy agents and exporters on `.53`, `.54`, and `.55`

Copy `remote-tools.yml`, `remote-tools.env`, and `alloy-config.alloy` from
`.52` to `/app/remote-tools` on each remote VM. Then create the environment
file for that VM:

| VM | `.env` settings |
|---|---|
| CCD `.53` | `REMOTE_BIND_ADDRESS=192.168.3.53`, `SERVER_NAME=ccd` |
| MCP `.54` | `REMOTE_BIND_ADDRESS=192.168.3.54`, `SERVER_NAME=mcp` |
| Langfuse `.55` | `REMOTE_BIND_ADDRESS=192.168.3.55`, `SERVER_NAME=langfuse` |

On each remote VM:

```bash
sudo install -d -m 0755 -o adminuser -g adminuser /app/remote-tools
cd /app/remote-tools
cp remote-tools.env .env
chmod 600 .env

# Edit REMOTE_BIND_ADDRESS and SERVER_NAME for this VM.
vi .env

docker compose -p remote-tools -f remote-tools.yml config -q
docker compose -p remote-tools -f remote-tools.yml pull
docker compose -p remote-tools -f remote-tools.yml up -d
docker compose -p remote-tools -f remote-tools.yml ps
```

On `.52`, allow inbound TCP `7004` only from `.53`, `.54`, and `.55` for Alloy.
Allow Redis TCP `7003` from those VMs only when their applications require it.
On each remote VM, allow inbound TCP `7100`, `7101`, and `9001` only from
`.52`. Apply equivalent Azure NSG rules.

Configure remote applications that use Redis with a secret-based equivalent of:

```env
REDIS_HOST=192.168.3.52
REDIS_PORT=7003
REDIS_PASSWORD=<Redis password from the tools VM>
```

The Docker hostname `redis` only works on `.52`; it does not span VMs.

## 11. Connect Portainer and reload Prometheus

In Portainer, add three **Agent** environments:

- CCD: `192.168.3.53:9001`
- MCP: `192.168.3.54:9001`
- Langfuse: `192.168.3.55:9001`

# for ccd 
- Open Environments → Add environment.
- Select Docker Standalone → Agent.
- Enter the environment address without a protocol:
192.168.3.53:9001
- connect (check the Environments)
- open .52 and run the commands
```sh
curl -kI https://192.168.3.53:9001
nc -vz 192.168.3.53 9001
```
- repeat the same for mcp and langflow
After all remote exporters are running, restart Prometheus on `.52`:
```bash
cd /app/tools
docker compose -p monitoring \
  -f monitoring.yml \
  -f logging.yml \
  -f grafana.yml restart prometheus

curl -fsS http://192.168.3.52:7001/api/v1/targets
curl -fsS http://192.168.3.53:7100/metrics >/dev/null
curl -fsS http://192.168.3.53:7101/metrics >/dev/null
```

All targets under `remote_node_exporters` and `remote_cadvisor` should be `UP`.
Repeat the direct exporter checks for `.54` and `.55` if any target is `DOWN`.
### check the redis connection in ccd
```sh
nc -vz 192.168.3.52 7003ai_redis

docker run --rm -it redis:8.6.5-alpine \
  redis-cli -h 192.168.3.52 -p 7003 --askpass ping
```
## 12. Query metrics and logs

In Grafana:
1. Open Explore.
2. Change the data source at the top from Prometheus to Loki.
3. Set the time range to Last 1 hour.
4. Run: label filters
service_name --> ccd-api-gateway
Options choose line limit - 100


Use the stable `server` label to select containers by VM:

```promql
container_last_seen{server="ccd"}
container_last_seen{server="mcp"}
container_last_seen{server="langfuse"}
```

To discover the actual Docker and Compose labels available on the series:

```promql
count by (server, name, image, container_label_com_docker_compose_service) (
  container_last_seen
)
```

In Grafana **Explore**, select the Loki data source and query remote logs:

```logql
{server="ccd"}
{server="mcp"}
{server="langfuse"}
```

Use `container_last_seen` for metrics. Use Loki queries for logs.

## 13. Accessing files versus applications

`/app/tools` is a directory on the VM, not a browser URL. Inspect its files over
SSH:

```bash
ls -al /app/tools
less /app/tools/Deployment_Instructions.md
```

The browser accesses the web applications through ports `7000` to `7002`.
Redis uses TCP port `7003`; it is not an HTTP or HTTPS endpoint.
Loki uses port `7004` for API requests and log ingestion; it has no standalone
web interface, so inspect logs through Grafana.
`http://192.168.3.52/tools` is not configured by this deployment. Supporting a
`/tools/...` URL would require a separate reverse-proxy configuration.

## 14. Optional dashboards

In Grafana, select **Dashboards > New > Import**:

- Node Exporter Full: dashboard ID `1860`
- Choose a maintained cAdvisor dashboard compatible with your cAdvisor metrics

Review imported dashboards before treating them as sandbox configuration.
