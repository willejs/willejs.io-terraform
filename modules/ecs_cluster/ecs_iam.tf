/* ecs iam role and policies */
resource "aws_iam_role" "ecs_role" {
  name               = "${var.project_name}-${var.environment}-ecs"
  assume_role_policy = "${file("${path.module}/iam_policies/ecs-role.json")}"
}

/* ecs service scheduler role */
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.project_name}-${var.environment}-ecs-service"
  policy = "${file("${path.module}/iam_policies/ecs-scheduler-role-policy.json")}"
  role   = "${aws_iam_role.ecs_role.id}"
}

/* ec2 container instance role & policy */

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "${var.project_name}-${var.environment}-ecs-instance"
  policy = "${file("${path.module}/iam_policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs_role.id}"
}

/* IAM profile to be used in auto-scaling launch configuration. */
resource "aws_iam_instance_profile" "ecs" {
  name  = "${var.project_name}-${var.environment}-ecs-instance"
  path  = "/"
  roles = ["${aws_iam_role.ecs_role.name}"]
}
