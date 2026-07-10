### Step 1: Create Additional Agents
- Since already have agent 01, let's create agents 03, 03, and 04 in separate directories:
```sh
/home/ai_ado/
├── myagent/                    # Agent 01 (existing - DON'T MOVE)
│   ├── .agent
│   ├── .credentials
│   ├── run.sh
│   └── _work/
├── agents/                     # New directory for additional agents
│   ├── ai-ado-agent-02/        # Agent 02
│   ├── ai-ado-agent-03/        # Agent 03
│   └── ai-ado-agent-04/        # Agent 04
```
- agent-01 is at 
```sh
find /home/ai_ado -name ".agent" 2>/dev/null

/home/ai_ado/myagent/.agent
```
```sh
cd /home/ai_ado
mkdir -p agents/ai-ado-agent-03
cd /home/ai_ado/agents/ai-ado-agent-03
wget https://download.agent.dev.azure.com/agent/5.275.0/vsts-agent-linux-x64-5.275.0.tar.gz
ll
tar xzvf vsts-agent-linux-x64-5.275.0.tar.gz
ll
rm -rf vsts-agent-linux-x64-5.275.0.tar.gz
# Configure with AAD
./config.sh
 Y
 https://dev.azure.com/inlai-projects/ (URL upto organization)
 Enter
Authentication Type: AAD

## You'll receive a device login code:
To sign in, use a web browser to open:

https://microsoft.com/devicelogin
```
- Option-1 use existing office id
```sh
Agent pool name : AILinuxAgentPool (for Azure)
 Enter agent name (press enter for ai-ado-agent-03) 
```
- Create Systemd Services for Each Agent
```sh
# Create service for ai-ado-agent-03
sudo tee /etc/systemd/system/ai-ado-agent-03.service > /dev/null << 'EOF'
[Unit]
Description=Azure DevOps Agent ai-ado-agent-03
After=network.target

[Service]
Type=simple
User=ai_ado
WorkingDirectory=/home/ai_ado/agents/ai-ado-agent-03
ExecStart=/home/ai_ado/agents/ai-ado-agent-03/run.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```
- run the following commands
```sh
sudo systemctl daemon-reload
sudo systemctl enable ai-ado-agent-03
sudo systemctl start ai-ado-agent-03
sudo systemctl status ai-ado-agent-03
```
- open agent pool and check the agents