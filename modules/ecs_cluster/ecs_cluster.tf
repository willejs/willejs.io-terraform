/* ecs service cluster */
resource "aws_ecs_cluster" "default" {
  name = "${var.project_name}-${var.environment}-ecs"
}
