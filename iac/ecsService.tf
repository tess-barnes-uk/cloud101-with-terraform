resource "aws_ecs_service" "this" {
  cluster         = module.ecs.cluster_id
  desired_count   = 1
  launch_type     = "FARGATE"
  name            = "${var.owner}-cloud101-service"
  task_definition = resource.aws_ecs_task_definition.this.arn

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    container_name   = "${var.owner}-cloud101-container"
    container_port   = 3000
    target_group_arn = aws_alb_target_group.app.arn
  }

  network_configuration {
    security_groups = [module.vpc.default_security_group_id, aws_security_group.ecs_tasks.id]
    subnets         = module.vpc.private_subnets
  }
}

output "public-url" { value = "http://${aws_alb.main.dns_name}" }