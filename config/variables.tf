variable "region" {
  default = "eu-central-1"
}

variable "cidr_block" {
  default = "172.17.0.0/16"
}

variable "az_count" {
  default = "2"
}

variable "ethereum_admin_account" {
  type = string
}
variable "ethereum_admin_private_key" {
  type = string
}

variable "bsc_mainnet_provider_url" {
  type = string
}