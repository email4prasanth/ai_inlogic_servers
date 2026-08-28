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
cat redis_password
unset REDIS_PASSWORD
echo

sudo chmod 755 /app/tools/monitoring.yml
sudo chmod 755 /app/tools/prometheus.yml
```

Do not commit or copy `grafana_admin_password`, `redis_password`, or `.env`
back into source control.

## 5. Validate the Compose models

Use Compose v2 (`docker compose`). Grafana and monitoring must be validated and
started as one combined model:

```bash
cd /app/tools
docker compose -p redis -f redis.yml config -q
echo $? #expect 0 as output
docker compose -p portainer -f portainer.yml config -q
echo $?
docker compose -p monitoring -f monitoring.yml -f grafana.yml config -q
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

## 8. Start Prometheus, exporters, and Grafana

```bash
docker compose -p monitoring -f monitoring.yml -f grafana.yml pull
docker compose -p monitoring -f monitoring.yml -f grafana.yml up -d --force-recreate
```

Prometheus: `http://192.168.3.52:7001`

Grafana: `http://192.168.3.52:7002`

Grafana username: `admin`; use the password stored in
`/app/tools/grafana_admin_password`. The Prometheus data source is provisioned
automatically as `http://prometheus:9090`.

## 9. Verify the deployment

```bash
docker compose -p redis -f redis.yml ps
docker compose -p portainer -f portainer.yml ps
docker compose -p monitoring \
  -f monitoring.yml \
  -f grafana.yml ps

docker compose -p redis -f redis.yml exec redis sh -c \
  'REDISCLI_AUTH="$(cat /run/secrets/redis_password)" redis-cli ping'
curl -kfsS https://192.168.3.52:7000/api/status
curl -fsS http://192.168.3.52:7001/-/ready
curl -fsS http://192.168.3.52:7002/api/health
curl -fsS http://192.168.3.52:7001/api/v1/targets
```

The Redis command should return `PONG`. In Prometheus, open the target health
page under **Status** and confirm `prometheus`, `node_exporter`, and `cadvisor`
are `UP`.

## 10. Accessing files versus applications

`/app/tools` is a directory on the VM, not a browser URL. Inspect its files over
SSH:

```bash
ls -al /app/tools
less /app/tools/Deployment_Instructions.md
```

The browser accesses the web applications through ports `7000` to `7002`.
Redis uses TCP port `7003`; it is not an HTTP or HTTPS endpoint.
`http://192.168.3.52/tools` is not configured by this deployment. Supporting a
`/tools/...` URL would require a separate reverse-proxy configuration.

## 11. Optional dashboards

In Grafana, select **Dashboards > New > Import**:

- Node Exporter Full: dashboard ID `1860`
- Choose a maintained cAdvisor dashboard compatible with your cAdvisor metrics

Review imported dashboards before treating them as sandbox configuration.
