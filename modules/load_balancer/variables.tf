variable "target_groups" {
  description = "Map of target group configurations"
  type = map(object({
    name        = string
    port        = number
    protocol    = string
    vpc_id      = string
    target_type = string
  }))
}

variable "listener" {
  description = "Map of listener configurations"
  type = map(object({
    elb_arn        = string
    protocol       = string
    port           = number
    default_action = object({
      type                  = string
      default_target_groups = list(string)
    })
  }))
}

variable "listener_rules" {
  description = "Listener rules with dynamic forward target groups"
  type = map(object({
    priority     = number
    listener_key = string
    condition = object({
      host_header = list(string)
    })
    forward_targets = list(object({
      target_group_key = string
      weight           = number
    }))
  }))
}

