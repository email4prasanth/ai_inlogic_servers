# owner access with high privilages
- Open subscription IAM click role assigment find the role it should be 
1. owner.
2. Key Vault Administrator
- click on + Add (add role assignment) under Role click on Previlaged administratior role, if you see User access administration, RBAC the privillage are good
- Else ask to give condition Allow user to assign all roles (highly privileged).

- Now open + Add (add role assignment) click on Previlaged administratior role select 
1. User access administration 
2. Key Vault Administrator
and add the member **ado-keyvault-sp** with condition Allow user to assign all roles except privileged administrator roles (Owner, UAA, RBAC) (Recommended).
```sh
# . Check Azure role assignments
az role assignment list --assignee 06b814ed-39fe-4db8-8dd3-25f977dfa24e --all --output table
# check condition
az role assignment list --assignee 06b814ed-39fe-4db8-8dd3-25f977dfa24e --include-condition --all
```

- check account privillages
```sh
az account show
az role assignment list --assignee 8531c979-7e49-45bc-9117-a08492bf1066 --all --output table
az role assignment list --scope /subscriptions/5b28ccaf-3a52-4a9d-a3b2-50270bd0f7db/resourceGroups/development-inlogicai-rg/providers/Microsoft.KeyVault/vaults/developmentinlogicaikv --output table
```