terraform {
  cloud {
    organization = "test-org"
    hostname = "app.terraform.io"

    workspaces {
      name = "pipeline-workspace"
    }
  }
}
