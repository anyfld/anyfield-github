terraform {
  required_version = ">= 1.14.4"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.10"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 7.17"
    }
  }

  backend "gcs" {
    bucket = "anyfield-github-terraform"
    prefix = "terraform/state"
  }
}

provider "github" {
  owner = local.github_owner
}

provider "google" {
  project = local.gcp_project_id
  region  = local.gcp_region
}

