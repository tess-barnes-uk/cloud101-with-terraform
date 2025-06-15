resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy_attachment" "ecs_instance" {
  name = "ecs-instance-policy-attachment"
  roles = [
    "${aws_iam_role.ecsTaskExecutionRole.id}"
  ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode([{
    essential    = true,
    image        = resource.docker_registry_image.exampleimage.name,
    name         = "${var.owner}-cloud101-container",
    portMappings = [{ containerPort = 3000, hostPort = 3000 }],
  }])
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "family-of-${var.owner}-tasks"
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # Only set the below if building on an ARM64 computer like an Apple Silicon Mac
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}