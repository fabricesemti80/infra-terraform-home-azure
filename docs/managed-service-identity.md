# Managed Service Identity creation

## Create a resource group

```powershell

PS D:\Scripts\terraform\own> az group create --name "tfid" --location "uksouth"
id: /subscriptions/f45a9cdc-bf42-4cec-8394-19cf4b3dbbca/resourceGroups/tfid
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
clientId: 9821deab-fffb-4baf-a028-6814ed5e08ce
id: /subscriptions/f45a9cdc-bf42-4cec-8394-19cf4b3dbbca/resourcegroups/tfid/providers/Microsoft.ManagedIdentity/userAssignedIdentities/terraform-msi
location: uksouth
name: terraform-msi
principalId: 10929d08-771b-4db4-9fbc-4b4305e5a158
resourceGroup: tfid
systemData: null
tags: {}
tenantId: af0666c0-1fa3-4622-9064-d7ac1e569de9
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
id: /subscriptions/f45a9cdc-bf42-4cec-8394-19cf4b3dbbca/providers/Microsoft.Authorization/roleAssignments/f12af43c-7111-4bf9-bae1-e65b8eddce87
name: f12af43c-7111-4bf9-bae1-e65b8eddce87
principalId: 10929d08-771b-4db4-9fbc-4b4305e5a158
principalType: ServicePrincipal
roleDefinitionId: /subscriptions/f45a9cdc-bf42-4cec-8394-19cf4b3dbbca/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c
scope: /subscriptions/f45a9cdc-bf42-4cec-8394-19cf4b3dbbca
type: Microsoft.Authorization/roleAssignments
updatedBy: 4ce9f816-8dcf-406a-a488-f25905005d0b
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
