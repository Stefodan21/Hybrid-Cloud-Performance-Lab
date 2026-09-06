variable "region" {
  type    = string
  default = "eastus"
}
variable "admin_username" {
  type = string
  default = "adminuser"
}

variable "resource_group_name" {
  type = string
  default = "rgtradingeastus001"
}

variable "tenant_id" {
  type = string
}


variable "container_name" {
  type = string
  default = "terraform"
}



variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
  }
}

variable "throughput" {
  type = number
}