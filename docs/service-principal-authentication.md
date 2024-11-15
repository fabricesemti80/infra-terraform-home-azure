# Service Principal authentication

>note: This is the preferred way, if you are running Terraform from *outside* of Azure or plan to do CI/CD

## Create **service principal**

```powershell
 az ad sp create-for-rbac --name "terraform-sp" --role Contributor --scope "/subscriptions/$(az account show --query id -o tsv)" --output json
```

![image](https://github.com/user-attachments/assets/b9dee8c1-a7f1-4a74-9d8d-f4140589f45c)

## Modify the provider config

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}
provider "azurerm" {
  features {}
  use_msi = false
}
```

>important:
> `use_msi` should **only be set to `true`** when the provider uses **managed service identity** (see more on this [here](https://github.com/hashicorp/terraform/issues/30549#issuecomment-1149136303) )


## Use these env vars

```sh
ARM_SUBSCRIPTION_ID                     # use `az account show` to display
ARM_TENANT_ID                           # use `az account show` to display
ARM_CLIENT_ID                           # use `az ad sp show --id $(az ad sp list --display-name "terraform-sp" --query "[].id" -o tsv) --query "id" -o tsv` to view or from GUI (see below)
ARM_CLIENT_SECRET (mark as sensitive)   # shown only at creation, GUI only shows partial (if lost, need to be rotated (?) )
```
![image](https://github.com/user-attachments/assets/be9b3121-d8b9-4786-8382-d9025ea1737a)

> important: DO NOT declare these variables as terraform-vars! they are going to be recognized by the module **without** this!

