variable "server_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_login" {
  type = string
}

variable "admin_pwd" {
  type = string
}

variable "collation" {
  type    = string
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "prevent_destroy" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "db_subnet_id" {
  type = string
}

variable "vnet_id" {
  type = string
  description = "VNet ID used for private dns zone link"
}