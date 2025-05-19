variable "deployments" {
  description = "A map of deployment configurations"
  type = map(object({
    app_name           = string
    cluster_name       = string
    service_name       = string
    deployment_group   = string
    listener_arn = list(string)
    target_group_1 = string
    target_group_2 = string

  }))
}
