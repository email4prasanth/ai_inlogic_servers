## pipeline azure-pipelines.yml
```sh
Azure DevOps Pipeline
        │
        ├── Build Docker Image
        ├── Push Image to ACR
        ├── Fetch Secrets from Azure Key Vault
        ├── Generate .env.databaseservice
        ├── Copy .env.databaseservice to VM (/tmp)
        ├── SSH into VM
        │      ├── Move .env.databaseservice → /app/backend/
        │      ├── Update docker-compose.yml image tag
        │      └── docker compose up -d --pull always --no-deps databaseservice
        │
        └── Cleanup
```
## VM Directory Structure
```sh
/app/backend
│
├── docker-compose.yml
├── .env.databaseservice
├── .env.loginauthservice
├── .env.apigateway
├── .env.configurationservice
├── .env.executewebservice
├── .env.executemobileservice
├── .env.checklistgeneration
├── .env.checklistllmparserservice
├── .env.adoservice
└── .env.databaseservice
```