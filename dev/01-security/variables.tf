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


variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "ingress_rules" {
  description = "Map of ingress rules"
  type = map(object({
    name        = string
    protocol    = string
    from_port   = number
    to_port     = number
    security_groups  = list(string)
  }))
}

variable "egress_rules" {
  description = "Egress rule for the security group"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

