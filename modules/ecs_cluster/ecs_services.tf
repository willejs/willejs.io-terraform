// create the willejs_io service
resource "aws_ecs_service" "willejs_io" {
  name              = "willejsio"
  cluster           = "${aws_ecs_cluster.default.id}"
  task_definition   = "${aws_ecs_task_definition.willejs_io.arn}"
  desired_count     = 2
  iam_role          = "${aws_iam_role.ecs_role.arn}"
  // don't roll out multiple versions at once, this causes port clashes without alb
  deployment_maximum_percent = 100
  // make sure a task is always active to avoid downtime.
  deployment_minimum_healthy_percent = 50

  // for now we are going to use an ELB to avoid complexities
  // TODO: use alb to do zero downtime and more intelligent healthchecks etc.
  load_balancer {
    elb_name        = "${aws_elb.ecs_asg_elb.name}"
    container_name  = "willejsio"
    container_port  = 80
  }
}

resource "template_file" "ecs_task_definition_willejs_io" {
  template = "${file("${path.module}/ecs_task_definitions/willejsio.json.tpl")}"

  vars {
    image_tag = "${var.willejs_io_version}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_task_definition" "willejs_io" {
  family = "willejsio"
  container_definitions = "${template_file.ecs_task_definition_willejs_io.rendered}"
}