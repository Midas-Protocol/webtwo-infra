variable "ecs_cluster_name" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {}
