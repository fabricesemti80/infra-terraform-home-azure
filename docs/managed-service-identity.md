# Managed Service Identity creation

## Create a resource group

```powershell

PS D:\Scripts\terraform\own> az group create --name "tfid" --location "uksouth"
id: /subscriptions/<your subscription>/resourceGroups/tfid
location: uksouth
managedBy: null
name: tfid
properties:
  provisioningState: Succeeded
tags: null
type: Microsoft.Resources/resourceGroups
```

## Create a managed service identity

```powershell
PS D:\Scripts\terraform\own> az identity create --name "terraform-msi" --resource-group "tfid"
clientId: <your clientID>
id: /subscriptions/<your subscription>/resourcegroups/tfid/providers/Microsoft.ManagedIdentity/userAssignedIdentities/terraform-msi
location: uksouth
name: terraform-msi
principalId: <your msi principal>
resourceGroup: tfid
systemData: null
tags: {}
tenantId: <your tenant>
type: Microsoft.ManagedIdentity/userAssignedIdentities
```

## Assign `contributor` role to the service identity

```powershell
PS D:\Scripts\terraform\own> az role assignment create --assignee-object-id "$(az identity show --name terraform-msi --resource-group tfid --query principalId -o tsv)" --role Contributor --scope "/subscriptions/$(az account show --query id -o tsv)"
RBAC service might reject creating role assignment without --assignee-principal-type in the future. Better to specify --assignee-principal-type manually.
condition: null
conditionVersion: null
createdBy: null
createdOn: '2024-11-13T14:54:42.763126+00:00'
delegatedManagedIdentityResourceId: null
description: null
id: /subscriptions/<your subscription>/providers/Microsoft.Authorization/roleAssignments/<your principals GUID>
name: <your principals GUID>
principalId: <your msi principal>
principalType: ServicePrincipal
roleDefinitionId: /subscriptions/<your subscription>/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c
scope: /subscriptions/<your subscription>
type: Microsoft.Authorization/roleAssignments
updatedBy: < user>
updatedOn: '2024-11-13T14:54:43.128125+00:00'
```

## Then obtain these as env variables

```sh
export ARM_USE_MSI=true
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
export ARM_TENANT_ID=$(az account show --query tenantId -o tsv)
export ARM_CLIENT_ID=$(az identity show --name terraform-msi --resource-group your-resource-group --query clientId -o tsv)
```

## And create the provider config

```hcl
provider "azurerm" {
  features {}
  use_msi = true
}


```
