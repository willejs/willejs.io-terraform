/* Set up the AWS provider */

provider "aws" {
  region = "eu-west-1"
}


/* Create A VPC with multi AZ private and public subnets */

module "vpc" {
  /* Use the comminity VPC module with a pinned revision number */
  source             = "git::https://github.com/terraform-community-modules/tf_aws_vpc.git?ref=1b14deb355b6771cf49612294995b112886a2d28"
  name               = "${var.project_name}"
  cidr               = "${var.vpc_subnet}"
  private_subnets    = "${var.private_subnets}"
  public_subnets     = "${var.public_subnets}"
  azs                = "${var.availability_zones}"
  /* This sets the search domain in DHCP options */
  enable_dns_support = true
}

/* SSH Keypair */
resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}-${var.environment}-default"
  public_key = "${file("${path.root}/${var.aws_ssh_key_file}.pub")}"
}

/* NAT gateway */

resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.nat_instance_count}"
}

resource "aws_nat_gateway" "gw" {
  count         = "${var.nat_instance_count}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(split(",", module.vpc.public_subnets), count.index)}"
}

resource "aws_route" "nat_instance" {
  route_table_id         = "${module.vpc.private_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.gw.*.id, count.index)}"
}

/* ECS Cluster */

module "ecs_cluster_1" {
  source = "../../modules/ecs_cluster"
  instance_id = "1"
  ec2_key_pair = "${aws_key_pair.default.key_name}"
  project_name = "${var.project_name}"
  environment = "${var.environment}"
  vpc_subnet = "${var.vpc_subnet}"
  vpc_id = "${module.vpc.vpc_id}"
  private_subnets    = "${module.vpc.private_subnets}"
  public_subnets     = "${module.vpc.public_subnets}"
}