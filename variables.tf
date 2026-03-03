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
  description = "define your password to web-servers"
  sensitive   = true
  default     = "testPass123" # todo: remove later so the user can define it
}

variable "app_server_size" {
  type = string
}

variable "app_servers_admin_pwd" {
  type        = string
  description = "define your password to web-servers"
  sensitive   = true
  default     = "testPass123" # todo: remove later so the user can define it
}

variable "db_admin_login" {
  type        = string
  description = "define your db admin login"
  default     = "dbadmin"
}

variable "db_pwd" {
  type        = string
  description = "define your password to the database"
  sensitive   = true
  default     = "testPass123" # todo: remove later so the user can define it
}