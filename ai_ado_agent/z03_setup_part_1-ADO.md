
#                                     AzureDevOps Part-1/2
## Creation of ADO Agent to run the jobs
### Launch server
- Take a linux server with 2 cpu, 8Gb RAM. 
    - use ssh@ai_ado@<publicip>, enter passsword
### Install tools
```sh
sudo vi tools.sh
sudo chmod +x tools.sh
sudo ./tools.sh
./tools.sh 2>&1 | tee bootstrap.log
```
### Establish connection between server and AzureDevOps UI
#### How to add the above server as an agent?
- Go to AzureDevOps Ai-Projects project at the left side bottom we can find project settings
- Go to organisation **inlai-projects** pipelines--> Agent pools, click on add pool select self-hosted and name it as “AILinuxAgentPool”, add full access.
- ![](https://github.com/email4prasanth/AzureDevOps/blob/master/azuredevopsimage/05-getagent.png)
    <!-- - agentpool -->

- Login to AZURE change hostname to `ai-ado-agent-01` 
    ```
    sudo nano /etc/hostname
    ai-ado-agent-01 #Replace the existing
    Check the tools terraform, ansible, packer, jq, curl, java (it will be there else install)
    reboot
    ```
#### PAT/AAD for AzureDevops Authentication refer below

#### Create an AMI to aviod the above steps
- create an AMI for future usage the total time consumed is 40 min if rg, subnet are created manually.
- If you want to launch using AMI use IAM role ``.
- We can see the default variable available in th linux agent click on capabilities we can target a specific and also add capability  AWS.
- **Next Step is to Clone the git hub  used for elastic bean stack**





