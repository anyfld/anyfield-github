terraform {
  required_version = ">= 1.14.3"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.10"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
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

