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
  default = "ghcr.io/midas-protocol/fuse-twap-bot:sha-3431e6accce0369f9fe9c81902f50155d858c44c"
}

variable "liquidator_bot_image" {
  type    = string
  default = "ghcr.io/midas-protocol/fuse-liquidator-bot:sha-bdb94d4d11b987820f44222c7b882006b0ab575a"
}