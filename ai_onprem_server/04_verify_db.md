```sh
docker inspect database_service | grep -A20 Env
or
docker exec -it database_service env
```
- Test through API Management
```sh
curl http://localhost:6000