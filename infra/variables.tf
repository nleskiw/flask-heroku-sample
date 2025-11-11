variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}

variable "repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "nleskiw/flask-heroku-sample"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "flask-heroku-sample-cluster"
}

variable "ecs_task_family" {
  description = "ECS task family name"
  type        = string
  default     = "flask-heroku-sample-task"
}

variable "ecr_repository_url" {
  description = "ECR repository URL for the Docker image"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "flask-heroku-sample-svc"
}

variable "vpc_id" {
  description = "VPC ID where the service will run"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the service ENIs"
  type        = list(string)
}

variable "container_port" {
  description = "Container (and host) port the app listens on"
  type        = number
  default     = 8000
}
