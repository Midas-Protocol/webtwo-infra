# Web 2 Infra: AWS Resources

Repository for all AWS resources related to Midas Capital. These are mainly comprised of liquidation bots and TWAP bots,
and the configs necessary to deploy them reliably and scalably.

## Components

Terraform Modules:

- `ecs`: ECS cluster definition and Autoscaling Group
- `ec2`: EC2 launch configuration
- `ecr`: permissions for ECS <-> ECR access
- `networking`: networking stacks
- `liquidation`: container definition for a liquidation bot
- `twap`: container definition for a TWAP bot (TODO)

## Adding a New Bot

### Liquidation Bot

Go to `config/main.tf` and duplicate the following code block:

```terraform
module "bsc_testnet_liquidation_bot" {
  source                      = "./modules/liquidation"
  ecs_cluster_sg              = module.network.ecs_task_sg
  allow_all_sg                = module.network.allow_all_sg
  execution_role_arn          = module.ecr.execution_role_arn
  cluster_id                  = module.ecs.ecs_cluster_id
  vpc_id                      = module.network.vpc_id
  public_subnets              = module.network.public_subnets
  docker_image                = "ghcr.io/midas-protocol/fuse-liquidator-bot:main"
  container_family            = "liquidation"
  chain_id                    = "97"
  cpu                         = 128
  memory                      = 64
  instance_count              = 1
  timeout                     = 180
  ethereum_admin_account      = var.ethereum_admin_account
  ethereum_admin_private_key  = var.ethereum_admin_private_key
  supported_input_currencies  = "0x0000000000000000000000000000000000000000,0xEC5dCb5Dbf4B114C9d0F65BcCAb49EC54F6A0867"
  supported_output_currencies = "0x0000000000000000000000000000000000000000,0xEC5dCb5Dbf4B114C9d0F65BcCAb49EC54F6A0867"
  web3_provider_url           = "https://data-seed-prebsc-1-s1.binance.org:8545"
}
```

Edit the fields:

```shell
supported_input_currencies
supported_output_currencies
web3_provider_url
chain_id
```

Commit and push. CI will take care of deploying the bot

### TWAP Bot

TODO
