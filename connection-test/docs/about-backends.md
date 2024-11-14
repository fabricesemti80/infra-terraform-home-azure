# notes

Back-end is critical for Terraform, so it is a good idea to understand it and chose the best one for your use case early on.

For the full documentation see [here](https://www.terraform.io/language/settings/backends/configuration) but in my case the choices are:

## Local backend

- this should be the starting point for most cases
- but only until working with others or CI/CD usage is not required (since  it is not shared)

```hcl
terraform {

}
```

## Remote backend

- this is the way to go for most cases, as long as we are happy to "outsource" the storage of the state to HashiCorp
- this is the default for Terraform Cloud

```hcl
terraform {

  backend "remote" {
    organization = "<your organization>" # org name from step 2.
    workspaces {
      name = "<your workspace>" # name for your app's state.
    }
  }
}
```

Using this the first time also requires `terraform login` to be run, which will open a browser window and will provide a token to be used in the command line.

## Cloud-specific backends

- Most cloud providers have their own backends
- I have experience with AWS and Azure
- An `Azure`-backend is used in the example below

```hcl
terraform {
   backend "azurerm" {
     resource_group_name  = "tfstate-rg"
     storage_account_name = "tfstatestorageaccountfs" 
     container_name       = "tfstate"                 
     key                  = "terraform.tfstate"
   }
}
```

> note: the `resource group`, `storage account` and `container` **has to be created before** the `terraform init`
> you can do this via the Azure CLI or the Azure Portal - or simply run terraform with no backend block defined (using `local` backend) --> this will create the resources for you --> then uncomment the backend block and run `terraform init --migrate-state` to migrate the state to the new backend!

