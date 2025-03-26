variable "client_secret" {
    type = string
    description = "The client secret of the service principal"
    sensitive = true  
}

variable "client_id" {
    type = string
    description = "The client id of the service principal"
}

variable "tenant_id" {
    type = string
    description = "The tenant id of the service principal"
}

variable "subscription_id" {
    type = string
    description = "The subscription id of the service principal"

}