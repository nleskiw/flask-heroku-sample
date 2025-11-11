resource "aws_security_group" "flask-heroku-sample-sg" {
  name        = "${var.ecs_service_name}-sg"
  description = "Allow inbound to Flask service"
  vpc_id      = var.vpc_id

  ingress {
    description = "Flask app"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    ipv6_cidr_blocks = [
      "::/0"
    ]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    ipv6_cidr_blocks = [
      "::/0"
    ]
  }

  tags = local.common_tags
}


resource "aws_ecs_service" "flask-heroku-sample-svc" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.flask-heroku-sample-cluster.id
  task_definition = aws_ecs_task_definition.flask-heroku-sample-task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = true
    subnets          = var.public_subnet_ids
    security_groups = [
      aws_security_group.flask-heroku-sample-sg.id
    ]
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  enable_execute_command = true

  tags = local.common_tags
}
