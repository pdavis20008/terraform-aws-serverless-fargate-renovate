# ECS IAM Resources
data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "ecs_service_policy" {
  count = var.create ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:Describe*",
      "ec2:DetachNetworkInterface"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_service" {
  count = var.create ? 1 : 0

  name               = "${local.ecs_cluster_name}-service-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_service" {
  count = var.create ? 1 : 0

  name   = "${local.ecs_cluster_name}-ecs-service-policy"
  role   = aws_iam_role.ecs_service[0].name
  policy = data.aws_iam_policy_document.ecs_service_policy[0].json
}

data "aws_iam_policy_document" "ecs_task_exec_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_exec_policy" {
  count = var.create ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [try(var.renovate_token_secret_arn, aws_secretsmanager_secret.renovate_token_secret[0].arn)]
  }
}

resource "aws_iam_role" "ecs_task_exec" {
  count = var.create ? 1 : 0

  name               = "${local.ecs_cluster_name}-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_exec_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_task_exec_policy" {
  count = var.create ? 1 : 0

  name   = "${local.ecs_cluster_name}-task-exec-policy"
  role   = aws_iam_role.ecs_task_exec[0].name
  policy = data.aws_iam_policy_document.ecs_task_exec_policy[0].json
}

data "aws_iam_policy_document" "renovate_task_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "renovate_task_policy" {
  count = var.create && length(var.renovate_task_policy_statements) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.renovate_task_policy_statements

    content {
      effect        = statement.value.effect
      actions       = statement.value.actions
      resources     = statement.value.resources
      sid           = try(statement.value.sid, null)
      not_actions   = try(statement.value.not_actions, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "condition" {
        for_each = length(statement.value.conditions) > 0 ? statement.value.conditions : []

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "renovate_task_role" {
  count = var.create ? 1 : 0

  name               = "${local.ecs_cluster_name}-renovate-task-role"
  assume_role_policy = data.aws_iam_policy_document.renovate_task_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy" "renovate_task_policy" {
  count = var.create && length(var.renovate_task_policy_statements) > 0 ? 1 : 0

  role   = aws_iam_role.renovate_task_role[0].name
  policy = data.aws_iam_policy_document.renovate_task_policy[0].json
}

# Task Schedule Role
data "aws_iam_policy_document" "renovate_task_schedule_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "renovate_task_schedule_policy" {
  count = var.create ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = [aws_ecs_cluster.this[0].arn]
    }
  }
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.renovate_task_role[0].arn,
      aws_iam_role.ecs_task_exec[0].arn
    ]
  }
}

resource "aws_iam_role" "renovate_task_schedule_role" {
  count = var.create ? 1 : 0

  name               = "${local.ecs_cluster_name}-task-schedule-role"
  assume_role_policy = data.aws_iam_policy_document.renovate_task_schedule_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy" "renovate_task_schedule_policy" {
  count = var.create ? 1 : 0

  name   = "${local.ecs_cluster_name}-task-schedule-policy"
  role   = aws_iam_role.renovate_task_schedule_role[0].name
  policy = data.aws_iam_policy_document.renovate_task_schedule_policy[0].json
}
