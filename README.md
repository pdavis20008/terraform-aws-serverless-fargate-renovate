# terraform-aws-serverless-fargate-renovate
Terraform Module for ECS Fargate-hosted RenovateBot

Based on https://github.com/mooyoul/serverless-renovate-fargate

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.renovate_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.renovate_schedule_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_task_definition.renovatebot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.renovate_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.renovate_task_schedule_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs_task_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.renovate_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.renovate_task_schedule_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.ecs_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_secretsmanager_secret.renovate_token_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_security_group.renovate_task_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_exec_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.renovate_task_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.renovate_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.renovate_task_schedule_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.renovate_task_schedule_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | A boolean flag to determine whether to create resources. | `bool` | `true` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The name of the ECS cluster for renovate bot | `string` | `"renovate"` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Enable container insights for the ECS cluster | `bool` | `false` | no |
| <a name="input_enable_enhanced_container_insights"></a> [enable\_enhanced\_container\_insights](#input\_enable\_enhanced\_container\_insights) | Enable enhanced container insights for the ECS cluster | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of a custom KMS key to use for encryption | `string` | `""` | no |
| <a name="input_kms_key_enable_rotation"></a> [kms\_key\_enable\_rotation](#input\_kms\_key\_enable\_rotation) | Whether to enable key rotation | `bool` | `true` | no |
| <a name="input_kms_key_rotation_in_days"></a> [kms\_key\_rotation\_in\_days](#input\_kms\_key\_rotation\_in\_days) | The number of days between key rotations | `number` | `365` | no |
| <a name="input_renovate_environment_variables"></a> [renovate\_environment\_variables](#input\_renovate\_environment\_variables) | A list of maps of environment variables to set for the ECS task from here. https://docs.renovatebot.com/self-hosted-configuration/ | `list(map(string))` | `[]` | no |
| <a name="input_renovate_schedule_task_count"></a> [renovate\_schedule\_task\_count](#input\_renovate\_schedule\_task\_count) | The number of tasks to run on the ECS cluster | `number` | `1` | no |
| <a name="input_renovate_task_cpu"></a> [renovate\_task\_cpu](#input\_renovate\_task\_cpu) | The number of CPU units to reserve for the ECS task | `number` | `1024` | no |
| <a name="input_renovate_task_family"></a> [renovate\_task\_family](#input\_renovate\_task\_family) | The family name of the ECS task definition for renovate bot | `string` | `"renovatebot"` | no |
| <a name="input_renovate_task_memory"></a> [renovate\_task\_memory](#input\_renovate\_task\_memory) | The amount of memory to reserve for the ECS task | `number` | `2048` | no |
| <a name="input_renovate_task_network_mode"></a> [renovate\_task\_network\_mode](#input\_renovate\_task\_network\_mode) | The network mode to use for the ECS task | `string` | `"awsvpc"` | no |
| <a name="input_renovate_task_policy_statements"></a> [renovate\_task\_policy\_statements](#input\_renovate\_task\_policy\_statements) | A list of statements to add to the ECS task role policy | <pre>list(object({<br>    effect        = string<br>    actions       = list(string)<br>    resources     = list(string)<br>    sid           = string<br>    not_actions   = optional(list(string))<br>    not_resources = optional(list(string))<br>    conditions = optional(list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_renovate_token_secret_arn"></a> [renovate\_token\_secret\_arn](#input\_renovate\_token\_secret\_arn) | The ARN of the secret containing the renovate token | `string` | `""` | no |
| <a name="input_renovate_version"></a> [renovate\_version](#input\_renovate\_version) | The version of renovate bot to use | `string` | `"latest"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | The number of days to retain log events | `number` | `30` | no |
| <a name="input_s3_log_bucket_name"></a> [s3\_log\_bucket\_name](#input\_s3\_log\_bucket\_name) | Optional: Name of an S3 bucket (additionally to CloudWatch) to store ECS logs. | `string` | `""` | no |
| <a name="input_s3_log_prefix"></a> [s3\_log\_prefix](#input\_s3\_log\_prefix) | Optional: Prefix to use for storing ECS logs in the S3 bucket. | `string` | `""` | no |
| <a name="input_schedule_cron_expression"></a> [schedule\_cron\_expression](#input\_schedule\_cron\_expression) | The cron expression to use for the ECS task schedule | `string` | `"cron(0 * ? * MON-FRI *)"` | no |
| <a name="input_schedule_state"></a> [schedule\_state](#input\_schedule\_state) | The state of the ECS task schedule | `string` | `"ENABLED"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of security group IDs to associate with the ECS task | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs to associate with the ECS task | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to associate with the ECS task | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_event_rule_name"></a> [cloudwatch\_event\_rule\_name](#output\_cloudwatch\_event\_rule\_name) | n/a |
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | n/a |
| <a name="output_ecs_role_arn"></a> [ecs\_role\_arn](#output\_ecs\_role\_arn) | n/a |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | n/a |
| <a name="output_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#output\_ecs\_task\_execution\_role\_arn) | n/a |
| <a name="output_ecs_task_name"></a> [ecs\_task\_name](#output\_ecs\_task\_name) | n/a |
| <a name="output_schedule_role_arn"></a> [schedule\_role\_arn](#output\_schedule\_role\_arn) | n/a |
| <a name="output_task_security_group_id"></a> [task\_security\_group\_id](#output\_task\_security\_group\_id) | n/a |
<!-- END_TF_DOCS -->
