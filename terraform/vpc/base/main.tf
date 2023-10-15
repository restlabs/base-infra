locals {
  public_subnet_list  = [ "0", "1", "2" ]       # needs to be strings
  private_subnet_list = [ "100", "101", "102" ] # needs to be strings
}

module "base_vpc" {
  source      = "../../modules/vpc"
  app_name    = var.app_name
  cidr_block  = "10.10.0.0/16"
  email       = var.email
  owner       = var.owner
  region      = var.region
  environment = data.aws_ssm_parameter.account_env.value
  project     = local.common_tags.project
  tags        = local.common_tags
}

module "base_igw" {
  source      = "../../modules/internet-gateway"
  app_name    = local.common_tags.project
  email       = var.email
  environment = data.aws_ssm_parameter.account_env.value
  owner       = var.owner
  project     = local.common_tags.project
  region      = var.region
  vpc_id      = module.base_vpc.vpc_id
  tags        = local.common_tags
}

### public subnets
module "public_subnets" {
  # Do not use "count", use "for_each".
  # Count might destroy additional subnets when a new subnet is added to the public_subnet_list.
  source             = "../../modules/aws-subnet"
  availability_zones = var.availability_zones
  is_public_ip_on    = true
  project            = local.common_tags.project
  subnet_list        = toset(local.public_subnet_list)
  vpc_id             = module.base_vpc.vpc_id
  subnet_type        = "public"
  tags               = merge(local.common_tags, { subnet_type = "public" })
}

resource "aws_default_route_table" "tf_default_rtb" {
  default_route_table_id = module.base_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.base_igw.id
  }

  tags = {
    Name = "${local.common_tags.project}-public-rtb"
  }
}

#resource "aws_nat_gateway" "tf_nat_gateway" {
#  connectivity_type = "private"
#  subnet_id         = aws_subnet.tf_public_subnets.id
#  tags = {
#    Name = "${local.common_tags.project}-natgw"
#  }
#}

### private subnets
#resource "aws_eip" "tf_eip" {
#  depends_on = [module.base_igw]
#}

module "private_subnets" {
  # Do not use "count", use "for_each".
  # Count might destroy additional subnets when a new subnet is added to the private_subnet_list.
  source             = "../../modules/aws-subnet"
  availability_zones = var.availability_zones
  is_public_ip_on    = false
  project            = local.common_tags.project
  subnet_list        = toset(local.private_subnet_list)
  vpc_id             = module.base_vpc.vpc_id
  subnet_type        = "private"
  tags               = merge(local.common_tags, { subnet_type = "private" })
}

resource "aws_route_table" "private_rtb" {
  vpc_id = module.base_vpc.vpc_id
  tags   = merge(local.common_tags, { Name = "${local.common_tags.project}-private-rtb" })
}

resource "aws_route_table_association" "private_rtb_association" {
  # for_each will fail here because tf cannot determine the length of the list from the module
  # use count here
  count          = length(module.private_subnets.subnet_ids)
  route_table_id = aws_route_table.private_rtb.id
  subnet_id      = module.private_subnets.subnet_ids[count.index]
}
