variable "create" {
  description = "A boolean flag to determine whether to create resources."
  type        = bool
  default     = true
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster for renovate bot"
  type        = string
  default     = "renovate"
}

variable "enable_container_insights" {
  description = "Enable container insights for the ECS cluster"
  type        = bool
  default     = false
}

variable "enable_enhanced_container_insights" {
  description = "Enable enhanced container insights for the ECS cluster"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "The ARN of a custom KMS key to use for encryption"
  type        = string
  default     = ""
}

variable "kms_key_rotation_in_days" {
  description = "The number of days between key rotations"
  type        = number
  default     = 365
}

variable "renovate_environment_variables" {
  description = "A list of maps of environment variables to set for the ECS task from here. https://docs.renovatebot.com/self-hosted-configuration/"
  type        = list(map(string))
  default     = []
}

variable "renovate_schedule_task_count" {
  description = "The number of tasks to run on the ECS cluster"
  type        = number
  default     = 1
}

variable "renovate_task_cpu" {
  description = "The number of CPU units to reserve for the ECS task"
  type        = number
  default     = 1024
}

variable "renovate_task_family" {
  description = "The family name of the ECS task definition for renovate bot"
  type        = string
  default     = "renovatebot"
}

variable "renovate_task_memory" {
  description = "The amount of memory to reserve for the ECS task"
  type        = number
  default     = 2048
}

variable "renovate_task_network_mode" {
  description = "The network mode to use for the ECS task"
  type        = string
  default     = "awsvpc"
}

variable "renovate_task_policy_statements" {
  description = "A list of statements to add to the ECS task role policy"
  type = list(object({
    effect        = string
    actions       = list(string)
    resources     = list(string)
    sid           = string
    not_actions   = optional(list(string))
    not_resources = optional(list(string))
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = []
}

variable "renovate_token_secret_arn" {
  description = "The ARN of the secret containing the renovate token"
  type        = string
  default     = ""
}

variable "renovate_version" {
  description = "The version of renovate bot to use"
  type        = string
  default     = "latest"
}

variable "retention_in_days" {
  description = "The number of days to retain log events"
  type        = number
  default     = 30
}

variable "s3_log_bucket_name" {
  description = "Optional: Name of an S3 bucket (additionally to CloudWatch) to store ECS logs."
  type        = string
  default     = ""
}

variable "s3_log_prefix" {
  description = "Optional: Prefix to use for storing ECS logs in the S3 bucket."
  type        = string
  default     = ""
}

variable "schedule_cron_expression" {
  description = "The cron expression to use for the ECS task schedule"
  type        = string
  default     = "cron(0 * ? * MON-FRI *)"
}

variable "schedule_state" {
  description = "The state of the ECS task schedule"
  type        = string
  default     = "ENABLED"
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the ECS task"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with the ECS task"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the ECS task"
  type        = string
  default     = ""
}
