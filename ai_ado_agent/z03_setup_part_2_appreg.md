#                                     AzureDevOps Part-2/2
## Creating App Registration & azure-pipeline.yml
### Clone the git hub if required and push the code to ADO
- create an empty folder `ai_repos` and open it by using powershell
```
cd ai_repos
git clone https://inlai-projects@dev.azure.com/inlai-projects/Ai-Projects/_git/inlogic_ai_infra
git clone https://inlai-projects@dev.azure.com/inlai-projects/Ai-Projects/_git/inlogic_ai_be
git clone https://inlai-projects@dev.azure.com/inlai-projects/Ai-Projects/_git/inlogic_ai_fe
```
- Use this code and do necessary modification create a new folder
```sh
git branch
git checkout -b develop
git push origin develop
git checkout -b feature/cicd
git push origin feature/cicd
```
## Step 1: Create an App Registration
```sh
Microsoft Entra ID  → App registrations  → New registration
| Setting                 | Value           |
| ----------------------- | --------------- |
| Name                    | ado-keyvault-sp |
| Supported account types | Single tenant   |
| Redirect URI            | None            |
```
- Grant Access to Azure Resources open InlogicAI subscription, Access control (IAM), click on add--> role assignment --> select Privileged administrator roles --> contributor access --> next --> User, group, or service principal--> select members **ado-keyvault-sp** (application registration) and create.

- Note client ID and Secret
```sh
Application (client) ID
Certificates & secrets  → Client secrets → New client secret
Description -  ADO-KeyVault 
select 365 days
copy the value
```
## Setp-2 Azure to ATO Conenction
- Establish connection ADO to Azure cloud, go to organisation --> project --> project settings--> under the Pipelines section service connections-->connection type (Azure Resource Manager).
```sh
    - Identity type: App registration or managed identity(manual)
    - Credential: secret
    - Environment: Azure Cloud
    - Subscription ID
    - Subscription name
    - Application (client) ID:
    - Directory (tenant) ID: 
    - Client secret:
    - Connection Name: AIproject_ADO_to_InlogicAI_Azure
    - Description: ADO AI Projects repo to Azure Portal InlogicAI connection
```
## Create required resource
1. Resource group **inlogicai-terraform-rg**.
2. storage account with container for terraform state list **inlogicaitfsto**
3. key vault to store service principal with name **adoagentkv**

- A fter kv is created Key Vault --> Access policies --> Create select permission -- choose
```sh
Secret, Key & Certificate Management
principal - ado-keyvalut-sp
keep others default
```
- add the key value pair 
- Store the secrtes under AI-projects --> pipelines --> library variable group with
```sh
Variable group name AZURE_ACCESS_GROUP_DEV
Description: Service principal for Development environment
Enable link secrets
provide subscription AIproject_ADO_to_InlogicAI_Azure
keyvault name adoagentkv
```
- refresh click on add you will see the secrets now integrate with azure keyvault.

## step 3:
- Now create yml file to create infra
```sh
Register the Main Pipeline (If you haven't already)
    - Go to Pipelines > Pipelines in Azure DevOps.
    - Click New pipeline -> Select your repo source -> Select your repo.
    - Choose Existing Azure Pipelines YAML file.
    - Change the branch dropdown to feature/cicd (since your code is there) and select /azure-pipelines.yml instead, then save it as AI-Infra-Deployment.
```
