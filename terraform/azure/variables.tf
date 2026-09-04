variable "region" {
    type = string
    default = "eastus"
}
variable "admin_username" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "tenant_id" {
    type = string
}

variable "storage_account_name" {
    type = string
}

variable "container_name" {
    type = string
}

variable "ssh_public_key" {
  type = string
}
