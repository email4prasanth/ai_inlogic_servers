# Overview
```sh
A user opens their browser and navigates to https://mmh-development.inlogictech.com. 
The DNS resolves this CNAME record to the Azure Static Web App at victorious-forest-06a11fb0f.7.azurestaticapps.net, which serves the frontend application (HTML, CSS, and JavaScript) to the user's browser. 
Once loaded, the frontend application runs in the browser and needs to fetch data from various backend services. 
It makes API calls to 
https://api-mmh-development.inlogictech.com for main backend operations, 
https://ccd-mmh-development.inlogictech.com for configuration and component data, 
https://mcp-mmh-development.inlogictech.com for model context protocol operations, and 
https://langfuse-mmh-development.inlogictech.com for LLM observability and tracing. 
These domains are A records that resolve directly to your individual VMs at IP addresses 192.168.3.65, 192.168.3.61, 192.168.3.62, and 192.168.3.60 respectively. 
The frontend communicates directly with these VMs via HTTPS, and each VM runs its respective service with Nginx handling SSL termination and routing requests to the appropriate Docker containers. 
So essentially, the CNAME record serves the user interface, while the A records power all the backend APIs that the frontend consumes.
```

### Create DNS Record for Development Environment 
```sh
Description
Need to create DNS records on GoDaddy for the Development environment domain.
    1. Record for Langfuse-Server
        Domain: https://langfuse-mmh-development.inlogictech.com
        Record Type: A Record
        IP Address: 192.168.3.60

    2. Record for CCD-Server
        Domain: https://ccd-mmh-development.inlogictech.com
        Record Type: A Record
        IP Address: 192.168.3.61

    3. Record for MCP-Server
        Domain: https://mcp-mmh-development.inlogictech.com
        Record Type: A Record
        IP Address: 192.168.3.62

    4. Record for BE-Server
        Domain: https://api-mmh-development.inlogictech.com
        Record Type: A Record
        IP Address: 192.168.3.65

    5. Record for Frontend Application
        Domain: https://mmh-development.inlogictech.com
        Record Type: CNAME Record
        Target Value: victorious-forest-06a11fb0f.7.azurestaticapps.net
        TTL: 300
```

# Add Custom Domain in Azure Portal (Recommended)
```SH
Go to your Static Web App in Azure Portal

Navigate to Settings → Custom domains

Add your custom domain: mmh-development.inlogictech.com

Azure will provide a TXT record for validation:

text
Domain: mmh-development.inlogictech.com
TXT Record: (Azure will give you a validation string)
Add the TXT record to your DNS provider

Wait for validation (usually 5-15 minutes)
```