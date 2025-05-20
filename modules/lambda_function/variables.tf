variable "function_name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "source_file" {
  type = string
}

variable "output_path" {
  type = string
}
