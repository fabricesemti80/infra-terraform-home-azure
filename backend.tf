terraform {
  cloud {

    organization = "homelab-fsemti"

    workspaces {
      name = "tf-azure"
    }
  }
}