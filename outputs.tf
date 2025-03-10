output "ecs_cluster_arn" {
  value = aws_ecs_cluster.this[0].arn
}

output "ecs_role_arn" {
  value = aws_iam_role.ecs_service[0].arn
}

output "ecs_task_name" {
  value = aws_ecs_task_definition.renovatebot[0].family
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.renovatebot[0].arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_exec[0].arn
}

output "task_security_group_id" {
  value = aws_security_group.renovate_task_sg[0].id
}

output "cloudwatch_event_rule_name" {
  value = aws_cloudwatch_event_rule.renovate_task[0].name
}

output "schedule_role_arn" {
  value = aws_iam_role.renovate_task_schedule_role[0].arn
}
