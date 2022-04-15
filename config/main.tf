terraform {
  backend "s3" {
    bucket = "terraform-statefile-midas-capital"
    key    = "midas-deployment"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

module "bsc_mainnet_twap_bot" {
  source                     = "./modules/twap"
  ecs_cluster_sg             = module.network.ecs_task_sg
  allow_all_sg               = module.network.allow_all_sg
  execution_role_arn         = module.ecr.execution_role_arn
  cluster_id                 = module.ecs.ecs_cluster_id
  docker_image               = var.twap_bot_image
  container_family           = "twap"
  chain_id                   = "56"
  cpu                        = 128
  memory                     = 64
  instance_count             = 1
  timeout                    = 180
  ethereum_admin_account     = var.ethereum_admin_account
  ethereum_admin_private_key = var.ethereum_admin_private_key
  supported_pairs            = "0x84392649eb0bC1c1532F2180E58Bae4E1dAbd8D6|0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c,0x61EB789d75A95CAa3fF50ed7E47b96c132fEc082|0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"
  web3_provider_url          = var.bsc_mainnet_provider_url
}


module "bsc_testnet_twap_bot" {
  source                     = "./modules/twap"
  ecs_cluster_sg             = module.network.ecs_task_sg
  allow_all_sg               = module.network.allow_all_sg
  execution_role_arn         = module.ecr.execution_role_arn
  cluster_id                 = module.ecs.ecs_cluster_id
  docker_image               = var.twap_bot_image
  container_family           = "twap"
  chain_id                   = "97"
  cpu                        = 128
  memory                     = 64
  instance_count             = 1
  timeout                    = 180
  ethereum_admin_account     = var.ethereum_admin_account
  ethereum_admin_private_key = var.ethereum_admin_private_key
  supported_pairs            = "0x575cb459b6e6b8187d3ef9a25105d64011874820|0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd,0x4D6F42B822A6Dff31e54f4FC1EEEffD5Ed8830Dd|0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd,0x012d9cEB1aaE02d31f5665275175Bd8A7c55CDd2|0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd,0x87F623e5Aa3dC1406598F311369549aE12ccfe84|0xd66c6B4F0be8CE5b39D52E0Fd1344c389929B378"
  web3_provider_url          = "https://data-seed-prebsc-1-s1.binance.org:8545"
}


module "bsc_mainnet_liquidation_bot" {
  source                      = "./modules/liquidation"
  ecs_cluster_sg              = module.network.ecs_task_sg
  allow_all_sg                = module.network.allow_all_sg
  execution_role_arn          = module.ecr.execution_role_arn
  cluster_id                  = module.ecs.ecs_cluster_id
  docker_image                = var.liquidator_bot_image
  container_family            = "liquidation"
  chain_id                    = "56"
  cpu                         = 128
  memory                      = 64
  instance_count              = 1
  timeout                     = 180
  ethereum_admin_account      = var.ethereum_admin_account
  ethereum_admin_private_key  = var.ethereum_admin_private_key
  supported_input_currencies  = "0x0000000000000000000000000000000000000000,0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c"
  supported_output_currencies = "0x0000000000000000000000000000000000000000,0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c,0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56,0x2170Ed0880ac9A755fd29B2688956BD959F933F8,0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c"
  web3_provider_url           = var.bsc_mainnet_provider_url
}


module "evmos_testnet_liquidation_bot" {
  source                      = "./modules/liquidation"
  ecs_cluster_sg              = module.network.ecs_task_sg
  allow_all_sg                = module.network.allow_all_sg
  execution_role_arn          = module.ecr.execution_role_arn
  cluster_id                  = module.ecs.ecs_cluster_id
  docker_image                = var.liquidator_bot_image
  container_family            = "liquidation"
  chain_id                    = "9000"
  cpu                         = 128
  memory                      = 64
  instance_count              = 1
  timeout                     = 180
  ethereum_admin_account      = var.ethereum_admin_account
  ethereum_admin_private_key  = var.ethereum_admin_private_key
  supported_input_currencies  = "0x0000000000000000000000000000000000000000,0xEC5dCb5Dbf4B114C9d0F65BcCAb49EC54F6A0867"
  supported_output_currencies = "0x0000000000000000000000000000000000000000,0xEC5dCb5Dbf4B114C9d0F65BcCAb49EC54F6A0867"
  web3_provider_url           = "https://eth.bd.evmos.dev:8545"
}


module "network" {
  source     = "./modules/networking"
  cidr_block = var.cidr_block
}


module "ecs" {
  source           = "./modules/ecs"
  ecs_cluster_name = "midas-ecs"
}

module "ec2" {
  source                 = "./modules/ec2"
  iam_instance_profile   = module.ecs.iam_instance_profile
  vpc_security_group_ids = [module.network.ecs_task_sg]
  instance_type          = "t3.micro"
  subnet_ids             = module.network.public_subnets
}


module "ecr" {
  source = "./modules/ecr"
}
