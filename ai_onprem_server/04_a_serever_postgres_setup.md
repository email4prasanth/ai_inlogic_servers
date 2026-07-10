## Set Up postgres
```sh
sudo mkdir -p /tools && cd /tools/
ls -al
sudo chmod -R 755 /tools/
sudo chown adminuser:adminuser /tools/
touch .env.databaseservice
nano docker-compose.yml
```
- details
```sh
DB_NAME=temp-db
DB_HOST=192.168.0.140
DB_PORT=5432
DB_USER=adminuser
DB_PASSWORD=Inlogic@123

DATABASE_URL_DEV=postgresql+asyncpg://adminuser:Inlogic@123@postgres:5432/inlogicai_public
```
- Check the connectivity using pgadmin and server
```sh
nc -zv localhost 5432
docker exec -it postgres psql -U adminuser -d postgres
```