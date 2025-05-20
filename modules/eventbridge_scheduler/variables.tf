variable "lambda_name" {
  type = string
}

variable "lambda_arn" {
  type = string
}

variable "schedules" {
  type = map(object({
    description = string
    expression  = string
    input = object({
      cluster           = string
      desired_count_off = number
      desired_count_1   = number
      desired_count_2   = number
      filter_string     = string
    })
  }))
}

