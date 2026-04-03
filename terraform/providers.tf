terraform {
  required_version = ">= 1.14.8"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.11"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 7.26"
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

