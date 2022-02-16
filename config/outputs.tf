output "ecs-cluster" {
  value = module.ecs.ecs_cluster_name
}

output "bsc-testnet-liquidation-bot" {
  value = module.bsc_testnet_liquidation_bot.service_name
}

