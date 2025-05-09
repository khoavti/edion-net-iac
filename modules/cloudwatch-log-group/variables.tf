variable "log_groups" {
  type = list(object({
    name              = string
    retention_in_days = number
    class             = string
  }))
}
