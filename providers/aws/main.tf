provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source             = "git::https://github.com/terraform-community-modules/tf_aws_vpc.git?ref=1b14deb355b6771cf49612294995b112886a2d28"
  name               = "${var.project_name}"
  cidr               = "${var.vpc_subnet}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  azs                = "${var.availability_zones}"
  enable_dns_support = true
}
