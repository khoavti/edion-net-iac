variable "clusters" {
  description = "Map of ECS clusters configurations"
  type = map(object({
    name = string
    container_insights = string
    log_name = string
  }))
}
