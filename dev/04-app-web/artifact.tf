resource "aws_s3_bucket" "artifact" {
  bucket = "edion-net-dev-codepipeline-artifact"
  force_destroy = true
}

data "aws_codestarconnections_connection" "github" {
  name = "repo-vti"
}