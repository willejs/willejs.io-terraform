// Autoscaling group launch config
resource "aws_launch_configuration" "ecs" {
  image_id        = "${var.ecs_image_id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.ec2_key_pair}"
  security_groups = ["${aws_security_group.ecs.id}"]

  // A little hacky, but this is ok for now.s
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.default.name} > /etc/ecs/ecs.config"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"

  // Use a decent sized block device as docker containers can grow if not cleaned up.
  root_block_device {
    volume_type = "gp2"
    volume_size = "60"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Create a autoscaling group
resource "aws_autoscaling_group" "ecs" {
  name                 = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  vpc_zone_identifier  = ["${var.private_subnets}"]
  load_balancers       = ["${aws_elb.ecs_asg_elb.name}"]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = "${var.project_name}"
    propagate_at_launch = true
  }

  min_size         = 2
  max_size         = 2
  desired_capacity = 2
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_subnet}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.project_name}-${var.environment}-ecs"
    created-by  = "terraform"
    environment = "${var.environment}"
    project     = "${var.project_name}"
  }
}
