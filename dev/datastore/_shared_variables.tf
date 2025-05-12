variable "log_groups" {
  type = list(object({
    name              = string
    retention_in_days = number
    class             = string
  }))
  default = [
    {
      name              = "/edion-net-dev/codepipeline/app-codepipeline"
      retention_in_days = 30
      class             = "STANDARD"
    },
    {
      name              = "/edion-net-dev/codepipeline/app-mgt-codepipeline"
      retention_in_days = 30
      class             = "STANDARD"
    },
    {
      name              = "/edion-net-dev/app/container-app-logs"
      retention_in_days = 30
      class             = "STANDARD"
    },
    {
      name              = "/edion-net-dev/app-mgt/container-app-logs"
      retention_in_days = 30
      class             = "STANDARD"
    }
  ]
}
