###
# ECS Cluster
###
resource "aws_ecs_cluster" "connector" {
  name = var.application_name
}

# ###
# # Task and Service
# ###
# data "template_file" "task_definition" {
#   template = file("${path.module}/templates/task_definition.json.tpl")
#   vars = {
#     aws_ecr_repository = var.ecr_url
#     tag                = var.container_image_version
#   }
# }

# resource "aws_ecs_task_definition" "connector" {
#   family                   = var.application_name
#   network_mode             = "awsvpc"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   cpu                      = 256
#   memory                   = 2048
#   requires_compatibilities = ["FARGATE"]
#   container_definitions    = data.template_file.task_definition.rendered
# }

# resource "aws_ecs_service" "connector" {
#   name            = var.application_name
#   cluster         = aws_ecs_cluster.connector.id
#   task_definition = aws_ecs_task_definition.connector.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     security_groups  = [aws_security_group.ecs_tasks.id]
#     subnets          = var.subnets
#     assign_public_ip = true
#   }
# }

# ###
# # Security Group
# ###
# resource "aws_security_group" "ecs_tasks" {
#   name        = "ecs-tasks"
#   description = "ECS tasks"
#   vpc_id      = var.vpc_id

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# data "aws_iam_policy_document" "ecs_task_execution_role" {
#   version = "2012-10-17"
#   statement {
#     sid     = ""
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name               = "ecs-execution-role"
#   assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }