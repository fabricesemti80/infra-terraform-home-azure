# Service Principal authentication

>note: This is a better way, if you are running Terraform from *outside* of Azure.

## Create **service principal**

```powershell
 az ad sp create-for-rbac --name "terraform-sp" --role Contributor --scope "/subscriptions/$(az account show --query id -o tsv)" --output json
```

![image](https://github.com/user-attachments/assets/b9dee8c1-a7f1-4a74-9d8d-f4140589f45c)

## Modify the provider config

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
```

## Ensure the variables are decared

```hcl
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "client_id" {
  type        = string
  description = "Azure Client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure Client Secret"
  sensitive   = true
}
```

## Use these env vars

```sh
ARM_SUBSCRIPTION_ID                     # use `az account show` to display
ARM_TENANT_ID                           # use `az account show` to display
ARM_CLIENT_ID                           # use `az ad sp show --id $(az ad sp list --display-name "terraform-sp" --query "[].id" -o tsv) --query "id" -o tsv` to view or from GUI (see below)
ARM_CLIENT_SECRET (mark as sensitive)   # shown only at creation, GUI only shows partial (if lost, need to be rotated (?) )
```
![image](https://github.com/user-attachments/assets/be9b3121-d8b9-4786-8382-d9025ea1737a)

