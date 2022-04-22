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
  default = "ghcr.io/midas-protocol/fuse-twap-bot:sha-6af9f2dbffde7e5b46aad1ba2dd6b249f49c4cac"
}

variable "liquidator_bot_image" {
  type    = string
  default = "ghcr.io/midas-protocol/fuse-liquidator-bot:sha-215d77dc24a07776e2ea76b2313becee7cdeacf3"
}