terraform {
  required_version = ">= 1.15.1"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.12"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 7.30"
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

