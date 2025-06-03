variable "taskdefs" {
  description = "Map of ECS task definitions"
  type = map(object({
    family                = string
    cpu                   = string
    memory                = string
    network_mode          = string
    execution_role_arn    = string
    task_role_arn         = optional(string)
    container_definitions = string
  }))
}
