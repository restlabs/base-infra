resource "aws_internet_gateway" "tf_gw" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.app_name}-igw" })
}