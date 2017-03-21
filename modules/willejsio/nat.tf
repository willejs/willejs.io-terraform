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
  ami               = "${data.aws_ami.nat_ami.image_id}"
  instance_type     = "t2.nano"
  subnet_id         = "${element(module.vpc.public_subnets, count.index)}"
  security_groups   = ["${aws_security_group.nat.id}"]
  key_name          = "${aws_key_pair.default.key_name}"
  source_dest_check = false

  count = "${length(var.public_subnets)}"
}

resource "aws_security_group" "nat" {
  name        = "${var.environment}-nat"
  description = "nat security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
    self        = true
  }
}

resource "aws_route" "nat_instance" {
  route_table_id         = "${element(module.vpc.private_route_table_ids, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${element(aws_instance.nat.*.id, count.index)}"
}
