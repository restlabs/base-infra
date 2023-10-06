locals {
  # needs to be strings
  subnet_list   = ["0", "1", "2"]
  code_location = "terraform/vpc/base"
}

module "base_vpc" {
  source        = "../../modules/vpc"
  app_name      = var.app_name
  cidr_block    = "10.10.0.0/16"
  code_location = local.code_location
  email         = var.email
  owner         = var.owner
  region        = var.region
  environment   = data.aws_ssm_parameter.account_env.value
  project       = local.common_tags.project
}

module "base_igw" {
  source        = "../../modules/internet_gateway"
  app_name      = local.common_tags.project
  code_location = local.code_location
  email         = var.email
  environment   = data.aws_ssm_parameter.account_env.value
  owner         = var.owner
  project       = local.common_tags.project
  region        = var.region
  vpc_id        = module.base_vpc.vpc_id
}

resource "aws_subnet" "tf_public_subnets" {
  for_each                = toset(local.subnet_list)
  availability_zone       = var.availability_zones[each.key]
  cidr_block              = "10.10.${each.value}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = module.base_vpc.vpc_id
  tags                    = merge(local.common_tags, { subnet_type = "public" }, { Name = "base-infra-public-${each.value}" })
}

resource "aws_default_route_table" "tf_default_rtb" {
  default_route_table_id = module.base_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.base_igw.id
  }

  tags = {
    Name = "${local.common_tags.project}-rtb"
  }
}
