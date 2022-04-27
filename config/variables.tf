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

variable "twap_bot_image" {
  type    = string
  default = "ghcr.io/midas-protocol/fuse-twap-bot:sha-a25ffa2fc0364ad6d1d6ac43b917a0d117a208ad"
}

variable "liquidator_bot_image" {
  type    = string
  default = "ghcr.io/midas-protocol/fuse-liquidator-bot:sha-ce9747db3aae2985966e327ec4a431c1f889b3e8"
}