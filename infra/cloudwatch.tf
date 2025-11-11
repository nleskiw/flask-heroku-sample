resource "aws_cloudwatch_log_group" "flask-heroku-sample" {
  name              = "/ecs/flask-heroku-sample"
  retention_in_days = 1

  tags = local.common_tags
}

