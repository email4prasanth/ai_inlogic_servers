#!/bin/sh
set -eu

redis_password="$(cat /run/secrets/redis_password)"
exec docker-entrypoint.sh redis-server \
  --appendonly yes \
  --requirepass "$redis_password"
