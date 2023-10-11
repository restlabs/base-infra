resource "aws_subnet" "tf_subnets" {
  # Do not use "count", use "for_each".
  # Count might destroy additional subnets when a new subnet is added to the public_subnet_list.
  for_each                = var.subnet_list
  availability_zone       = var.availability_zones[index(tolist(var.subnet_list), each.value)]
  cidr_block              = "10.10.${each.value}.0/24"
  map_public_ip_on_launch = var.is_public_ip_on
  vpc_id                  = var.vpc_id
  tags                    = merge(var.tags, { Name = "${var.project}-${var.subnet_type}-${each.value}" })
}