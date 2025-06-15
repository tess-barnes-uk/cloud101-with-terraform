# security.tf

# ALB security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "${var.owner}-c101-load-balancer-sg"
  description = "controls access to the ALB"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = var.external_port
  to_port           = var.app_port
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.lb.id
  # far too open
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
  # from_port   = 0
  # to_port     = 0
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.owner}-c101-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "ecs_tasks" {
  security_group_id = aws_security_group.ecs_tasks.id
  # far too open but should work to connect to ECR etc. Best to have a vpc endpoint for most secure but this comes with some additional expense.
  cidr_ipv4 = "0.0.0.0/0"
  # cidr_ipv4 = "3.8.0.0/16" #ECR ip ranges only but amazon ip ranges are hugely wideranging. 
  ip_protocol = "-1"
  # from_port   = 0
  # to_port     = 0
}

resource "aws_vpc_security_group_ingress_rule" "ecs_tasks" {
  security_group_id            = aws_security_group.ecs_tasks.id
  referenced_security_group_id = aws_security_group.lb.id
  ip_protocol                  = "tcp"
  from_port                    = var.external_port
  to_port                      = var.app_port
}
