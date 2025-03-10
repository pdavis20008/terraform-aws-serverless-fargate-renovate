resource "aws_cloudwatch_event_rule" "renovate_task" {
  count = var.create ? 1 : 0

  name                = "${local.ecs_cluster_name}-renovate-schedule"
  description         = "Task schedule for renovatebot on ECS Cluster: ${local.ecs_cluster_name}"
  schedule_expression = var.schedule_cron_expression
  state               = var.schedule_state

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "renovate_schedule_target" {
  count = var.create ? 1 : 0

  rule     = aws_cloudwatch_event_rule.renovate_task[0].name
  arn      = aws_ecs_cluster.this[0].arn
  role_arn = aws_iam_role.renovate_task_schedule_role[0].arn
  ecs_target {
    task_count          = var.renovate_schedule_task_count
    task_definition_arn = aws_ecs_task_definition.renovatebot[0].arn
  }
}
