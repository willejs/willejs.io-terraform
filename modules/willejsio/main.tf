// Set up the AWS provider

provider "aws" {
  region = "eu-west-1"
}

// Create A VPC with multi AZ private and public subnets

module "vpc" {
  // Use the comminity VPC module with a pinned revision number
  source          = "git::https://github.com/terraform-community-modules/tf_aws_vpc.git?ref=2f1b5ed3d508b0c9dba2d5d5ea6f4b567714ef1c"
  name            = "${var.project_name}"
  cidr            = "${var.vpc_subnet}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"
  azs             = "${var.availability_zones}"

  // This sets the search domain in DHCP options
  enable_dns_support = true
}

// SSH Keypair
resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}-${var.environment}-default"
  public_key = "${file("${path.root}/${var.aws_ssh_key_file}.pub")}"
}

// ECS Cluster
module "ecs_cluster_1" {
  source          = "../ecs_cluster"
  instance_id     = "1"
  ec2_key_pair    = "${aws_key_pair.default.key_name}"
  project_name    = "${var.project_name}"
  environment     = "${var.environment}"
  vpc_subnet      = "${var.vpc_subnet}"
  vpc_id          = "${module.vpc.vpc_id}"
  private_subnets = "${module.vpc.private_subnets}"
  public_subnets  = "${module.vpc.public_subnets}"
  ssl_cert_arn    = "${data.aws_acm_certificate.willejs_io.arn}"
}
