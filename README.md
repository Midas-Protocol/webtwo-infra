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

## Adding a Liquidation Bot

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
  docker_image                = "ghcr.io/midas-protocol/fuse-liquidator-bot:<sha:commit-hash>"
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

Change the name of the module to something meaningful, e.g. `evmos_mainnet_liquidation_bot`

Edit the fields:

```shell
supported_input_currencies
supported_output_currencies
web3_provider_url
chain_id
```

For the `docker_image` you can find the latest commit hash in
the [fuse-liquidator-bot image releases](https://github.com/Midas-Protocol/fuse-liquidator-bot/pkgs/container/fuse-liquidator-bot)

Commit and push. CI will take care of deploying the bot.

## Adding a TWAP Bot

Same as before, but with the following block:

```terraform
module "bsc_mainnet_twap_bot" {
  source                     = "./modules/twap"
  ecs_cluster_sg             = module.network.ecs_task_sg
  allow_all_sg               = module.network.allow_all_sg
  execution_role_arn         = module.ecr.execution_role_arn
  cluster_id                 = module.ecs.ecs_cluster_id
  docker_image               = "ghcr.io/midas-protocol/fuse-twap-bot:<sha:commit-hash>"
  container_family           = "twap"
  chain_id                   = "97"
  cpu                        = 128
  memory                     = 64
  instance_count             = 1
  timeout                    = 180
  ethereum_admin_account     = var.ethereum_admin_account
  ethereum_admin_private_key = var.ethereum_admin_private_key
  supported_pairs            = "0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16|0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c,0x74E4716E431f45807DCF19f284c7aA99F18a4fbc|0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c,0x61EB789d75A95CAa3fF50ed7E47b96c132fEc082|0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"
  web3_provider_url          = "https://data-seed-prebsc-1-s1.binance.org:8545"
}
```

Edit the fields:

```shell
supported_pairs
web3_provider_url
chain_id
```

- `supported_pairs` format: comma separated `<pair_address>|<base_token>` values.
  `pair_address` is the pair's address as calculated by the
  [Uniswap Factory `getPair` function](https://docs.uniswap.org/protocol/V2/reference/smart-contracts/factory#getpair),
  and the base token is the base token of the pair.

### Supported Input Pairs & Addresses

**BSC Testnet: PCS**

Addresses

```shell
WBNB: 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd 
BUSD: 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee 
ETH: 0x8babbb98678facc7342735486c851abd7a0d17ca 
BTCB: 0x6ce8dA28E2f864420840cF74474eFf5fD80E65B8
```

Pair Addresses

```shell
WBNB-BUSD: 0x575cb459b6e6b8187d3ef9a25105d64011874820
WBNB-ETH: 0x0ccF78E575af2dCFF6E96135A06e0A45Ff45F7E8 
WBNB-BTCB: 0x012d9cEB1aaE02d31f5665275175Bd8A7c55CDd2
```

**BSC Mainnet: PCS**

Addresses

```shell
WBNB: 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c 
BUSD: 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56 
ETH: 0x2170Ed0880ac9A755fd29B2688956BD959F933F8
BTCB: 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c
BOMB: 0x522348779DCb2911539e76A1042aA922F9C47Ee3

```

Pair Addresses

```shell
WBNB-BUSD: 0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16
WBNB-ETH: 0x74E4716E431f45807DCF19f284c7aA99F18a4fbc 
WBNB-BTCB: 0x61EB789d75A95CAa3fF50ed7E47b96c132fEc082
BOMB: 0x522348779DCb2911539e76A1042aA922F9C47Ee3
```


