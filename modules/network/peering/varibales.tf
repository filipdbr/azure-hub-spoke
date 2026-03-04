# variables of the 1st vnet
variable "vnet1_name_hub" {
  type = string
}

variable "vnet1_id_hub" {
  type = string
}

variable "vnet1_rg_name_hub" {
  type = string
}

# variables of the 2nd vnet
variable "vnet2_name_spoke" {
  type = string
}

variable "vnet2_id_spoke" {
  type = string
}

variable "vnet2_rg_name_spoke" {
  type = string
}

variable "use_remote_gateway" {
  type    = bool
  default = false
}

variable "allow_gateway_transit" {
  type    = bool
  default = false
}