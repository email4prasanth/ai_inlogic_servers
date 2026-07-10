### Introduction to AzurDevOps CI/CD
#### AzureDevOps pipeline
- Azure is a cloud AzureDevOps - Saas based tool - is a solution
    - Repos
    - Pipelines
    - Kanban Boards
    - Test Cases
    - Artifacts

- **PART-1:**
1. Onprem instance with atleast 2 CPU, 8GB RAM.
2. Install the required tools
    - java
    - jq, curl, wget, net-tools etc
    - Terrform - provisioning and resource creation
    - ansible (edit default config settting) - configure the servers
    - packer - to create AMI
    - AZ CLI
    - AWS CLI
    - Docker
    - reboot
3. To establish connection between server and AzureDevOps UI, 
    - Azure DevOps Self-Hosted Agent Registration PAT/AAD for AzureDevOPS Registration
    - Change the hostname of the server and reeboot the system.
    - Open an agent pool in AzureDevOps UI, add new agent select LINUX and paste the instructions in the server.
    - Once the connection is established create an AMI.
- **PART-2:**
4. Creation of `azure-pipelines.yml`
    - Use powershell and Clone a repositoy whcih contain a java/Maven that can deploy the ROOT.war archive that build.sh
    - Delete the git folder(maps to git repo) and intialize git in order to push it into ADO.
    - Open Agentpool select agent add necessary User-defined capabilities.
    - Create a pipeline in ADO, since we are using self hosted replace `vmImage` with `name` demands User-defined capabilities.
    - Run the code YOU will see the job is successful at
        - Server
        - ADO UI. 