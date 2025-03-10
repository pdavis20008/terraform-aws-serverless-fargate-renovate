data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  ecs_cluster_name = var.ecs_cluster_name == "renovate" ? "${var.ecs_cluster_name}-ecs-cluster" : var.ecs_cluster_name
}

# ECS Cluster
resource "aws_ecs_cluster" "this" {
  count = var.create ? 1 : 0

  name = local.ecs_cluster_name

  configuration {
    execute_command_configuration {
      kms_key_id = length(var.kms_key_arn) > 0 ? var.kms_key_arn : aws_kms_key.ecs_logs[0].arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs[0].name
        s3_bucket_name                 = length(var.s3_log_bucket_name) > 0 ? var.s3_log_bucket_name : null
        s3_key_prefix                  = length(var.s3_log_prefix) > 0 ? var.s3_log_prefix : null
        s3_bucket_encryption_enabled   = true
      }
    }
  }

  dynamic "setting" {
    for_each = var.enable_container_insights && !var.enable_enhanced_container_insights ? [1] : []

    content {
      name  = "containerInsights"
      value = "enabled"
    }
  }

  dynamic "setting" {
    for_each = !var.enable_container_insights && !var.enable_enhanced_container_insights ? [1] : []

    content {
      name  = "containerInsights"
      value = "disabled"
    }
  }

  dynamic "setting" {
    for_each = !var.enable_container_insights && var.enable_enhanced_container_insights ? [1] : []

    content {
      name  = "containerInsights"
      value = "enhanced"
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  count = var.create ? 1 : 0

  name              = "/aws/ecs/${local.ecs_cluster_name}"
  retention_in_days = var.retention_in_days

  tags = var.tags
}

resource "aws_kms_key" "ecs_logs" {
  count = var.create ? 1 : 0

  description             = "Key for ECS Cluster: ${local.ecs_cluster_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = var.kms_key_enable_rotation
  rotation_period_in_days = var.kms_key_rotation_in_days

  tags = var.tags
}

resource "aws_secretsmanager_secret" "renovate_token_secret" {
  count = var.create ? 1 : 0

  name        = "${local.ecs_cluster_name}-renovate-token"
  description = "Renovate token for ECS Cluster: ${local.ecs_cluster_name}"

  tags = var.tags
}

# ECS Task Definition
resource "aws_ecs_task_definition" "renovatebot" {
  count = var.create ? 1 : 0

  family                   = var.renovate_task_family
  cpu                      = var.renovate_task_cpu
  memory                   = var.renovate_task_memory
  network_mode             = var.renovate_task_network_mode
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_exec[0].arn
  task_role_arn            = aws_iam_role.renovate_task_role[0].arn

  container_definitions = jsonencode({
    name   = "renovatebot"
    cpu    = var.renovate_task_cpu
    memory = var.renovate_task_memory
    image  = "renovate/renovate:${var.renovate_version}"

    command = [
      "balmbees/vingle-report"
    ]

    log_configuration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs[0].name,
        "awslogs-region"        = data.aws_region.current.name,
        "awslogs-stream-prefix" = "renovatebot"
      }
    }

    environment = [
      for env in var.renovate_environment_variables : {
        name  = env.name
        value = env.value
      }
    ]

    secrets = [
      {
        name      = "RENOVATE_TOKEN"
        valueFrom = aws_secretsmanager_secret.renovate_token_secret[0].arn
      }
    ]

    awsVpcConfiguration = {
      securityGroups = concat([aws_security_group.renovate_task_sg[0].id], var.security_group_ids)
      subnets        = var.subnet_ids
    }
  })

  tags = var.tags
}

# Networking
resource "aws_security_group" "renovate_task_sg" {
  count = var.create ? 1 : 0

  name        = "${local.ecs_cluster_name}-renovate-task-sg"
  description = "Security group for Renovate ECS Task"
  vpc_id      = var.vpc_id

  tags = var.tags
}
