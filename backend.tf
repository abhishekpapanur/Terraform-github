terraform {
  cloud {
    organization = "abhi_papanur"

    workspaces {
      name = "Terraform-AWS-github"
    }
  }
}