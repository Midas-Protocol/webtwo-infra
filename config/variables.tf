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
  default = "ghcr.io/midas-protocol/fuse-twap-bot:sha-a4239df77a05383741ca5cfde3d04cd3e7f6212e"
}

variable "liquidator_bot_image" {
  type    = string
  default = "ghcr.io/midas-protocol/fuse-liquidator-bot:sha-99aa5669499b02631e897f8873fab6b91a1b7946"
}