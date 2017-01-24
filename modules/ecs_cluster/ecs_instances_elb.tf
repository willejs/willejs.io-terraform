# Create a new load balancer
resource "aws_elb" "ecs_asg_elb" {
  name     = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
  subnets  = ["${split(",", var.public_subnets)}"]
  internal = false

  listener {
    instance_port     = "8080"
    instance_protocol = "http"
    lb_port           = "80"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  tags {
    Name = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
  }

  security_groups = ["${aws_security_group.ecs_asg_elb.id}"]
}

resource "aws_security_group" "ecs_asg_elb" {
  name          = "${var.project_name}-${var.environment}-elb-ecs-${var.instance_id}"
  description   = "Security group allowing traffic to the ELB"
  vpc_id        = "${var.vpc_id}"

  tags {
    Name        = "${var.project_name}-${var.environment}-elb-ecs-${var.instance_id}"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}