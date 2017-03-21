// Use AWS instances as NAT gateway as they are $$$ cheaper

data "aws_ami" "nat_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
}

resource "aws_instance" "nat" {
  ami                    = "${data.aws_ami.nat_ami.image_id}"
  instance_type          = "t2.nano"
  subnet_id              = "${element(module.vpc.public_subnets, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  key_name               = "${aws_key_pair.default.key_name}"
  source_dest_check      = false

  count = "${length(var.public_subnets)}"
}

resource "aws_security_group" "nat" {
  name        = "${var.environment}-nat"
  description = "nat security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${module.vpc.vpc_id}"
}

resource "aws_security_group_rule" "allow_ssh" {
  type        = "ingress"
  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = ["${var.nat_ssh_allowed_ip}"]

  security_group_id = "${aws_security_group.nat.id}"

  count = "${var.nat_ssh_allowed ? 1 : 0 }"
}

resource "aws_security_group_rule" "allow_all_local" {
  type        = "ingress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/8"]

  security_group_id = "${aws_security_group.nat.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = "0"
  to_port     = "0"
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.nat.id}"
}

resource "aws_route" "nat_instance" {
  route_table_id         = "${element(module.vpc.private_route_table_ids, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${element(aws_instance.nat.*.id, count.index)}"

  // currently you cant evaluate dynamic outputs of modules
  count = "${length(var.private_subnets)}"
}
