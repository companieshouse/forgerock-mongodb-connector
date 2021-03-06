data "template_file" "container_definitions" {
  template = file("${path.module}/templates/container_definitions.json.tpl")
  vars = {
    aws_ecr_url               = var.ecr_url
    tag                       = var.container_image_version
    cloudwatch_log_group_name = var.log_group_name
    cloudwatch_log_prefix     = var.log_prefix
    region                    = var.region
    ds_password               = var.ds_password
  }
}

resource "aws_ecs_task_definition" "ds" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_role_arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.container_definitions.rendered

  tags = var.tags
}

resource "aws_security_group" "ds" {
  name        = "${var.service_name}-ds"
  description = "${var.service_name} directory service"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 389
    to_port     = 389
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = var.tags
}

resource "aws_ecs_service" "ds" {
  name            = var.service_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ds.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_task_security_group_id, aws_security_group.ds.id]
    subnets          = var.subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "directory-service"
    container_port   = 389
  }

  tags = var.tags
}
