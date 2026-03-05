variable "location" {
  type        = string
  description = "main region for all Azure resources"
}

variable "vmss_size" {
  type        = string
  description = "our default SKU - great value for money and perfect for testing purposes"
}

variable "storage_account_type" {
  type        = string
  description = "you can define your own value, however I recemmend keeping Standard_LRS"
}

variable "vmss_admin_pwd" {
  type        = string
  description = "password to web-servers"
  sensitive   = true
}

variable "app_server_size" {
  type = string
}

variable "app_servers_admin_pwd" {
  type        = string
  description = "password to app-servers"
  sensitive   = true
}

variable "db_admin_login" {
  type        = string
  description = "define your db admin login"
  default     = "dbadmin"
}

variable "db_pwd" {
  type        = string
  description = "password to the database"
  sensitive   = true
}

variable "shared_key_vpn" {
  type      = string
  description = "shared key defined by user"
  sensitive = true
}

variable "office_city" {
  type = string
}

variable "pip_office" {
  type        = string
  description = "public IP of the office"
}

variable "office_address_space" {
  type        = list(string)
  description = "address space of your office"
  default     = []
}