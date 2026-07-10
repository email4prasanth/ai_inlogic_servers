  authlogin_service:
    container_name: authlogin_service
    image:  developmentinlogicairegistry.azurecr.io/authlogin_service:latest
    restart: unless-stopped
    ports:
      - "6001:6001"
    env_file:
      - .env.authloginservice
    networks:
      - shared_network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:6001/api/health"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 20s