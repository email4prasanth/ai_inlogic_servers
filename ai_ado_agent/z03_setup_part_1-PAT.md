#### PAT for AzureDevops Authentication
- For authentication
    - Click on settting (right top corner) new tab on PAT
    - New token
    - Name- DevOpsADOToken
    - Organization - testingdkuttiado
    - Expire for 10 days
    - Scope -full access
    - Create
    - Copy and save
#### Creating AGENT in the server using AzureDevOps UI 
- Once you are in `/home/ai_ado` click on `New Agent` select **Linux**, copy and paste in the ubuntu server, make sure you are using `ai_ado` user.
```
 mkdir myagent && cd myagent
 - copy Download the agent, then open server
 wget https://vstsagentpackage.azureedge.net/agent/4.274.1/vsts-agent-linux-x64-4.274.1.tar.gz
 ll (agent got downloaded)
 tar xzvf https://vstsagentpackage.azureedge.net/agent/4.274.1/vsts-agent-linux-x64-4.274.1.tar.gz
 ll
 sudo rm -rf vsts-agent-linux-x64-4.274.1.tar.gz
 ./config.sh
 Y
 https://dev.azure.com/inlai-projects/ (URL upto organization)
 Enter
 Token paste PAT
 Agent pool name : AzureAgentPool (for Azure)
 Enter agent name (press enter for azureadoagent) 
 - _work folder will create
 enter
 Install Agent as Service
./run.sh & 
```
- ./run.sh & (this apsersent (&) will run in the backed end even if you come out from the putty)
- 50:27 agent is ready.