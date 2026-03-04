variable "vpn_gateway_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "gateway_subnet_id" {
  type = string
}

variable "pip_office" {
  type = string
}

variable "shared_key" {
  type      = string
  sensitive = true
}

variable "office_city" {
  type = string
}

variable "office_address_space" {
  type    = list(string)
  default = []
}