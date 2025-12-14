resource "google_project_service" "required_apis" {
  for_each = toset([
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
  ])

  project = local.gcp_project_id
  service = each.value

  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = local.gcp_project_id
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Workload Identity Pool for GitHub Actions OIDC authentication"

  depends_on = [google_project_service.required_apis]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = local.gcp_project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Provider"
  description                        = "OIDC provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
    "attribute.workflow"         = "assertion.workflow"
    "attribute.environment"      = "assertion.environment"
  }

  attribute_condition = "assertion.repository_owner == \"${local.github_owner}\" && assertion.repository == \"${local.github_owner}/${local.github_repository_name}\""

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "terraform" {
  project      = local.gcp_project_id
  account_id   = "terraform-github-actions"
  display_name = "Terraform GitHub Actions Service Account"
  description  = "Service account for GitHub Actions to run Terraform operations"

  depends_on = [google_project_service.required_apis]
}

resource "google_storage_bucket_iam_member" "terraform_state" {
  bucket = local.gcs_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_member" "terraform_service_usage_admin" {
  project = local.gcp_project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_member" "terraform_viewer" {
  project = local.gcp_project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_member" "terraform_workload_identity_admin" {
  project = local.gcp_project_id
  role    = "roles/iam.workloadIdentityPoolAdmin"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_member" "terraform_storage_admin" {
  project = local.gcp_project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_service_account_iam_member" "github_actions_impersonate" {
  service_account_id = google_service_account.terraform.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${local.github_owner}/${local.github_repository_name}"
}

data "google_project" "project" {
  project_id = local.gcp_project_id
}

resource "github_actions_secret" "wif_provider" {
  repository      = local.github_repository_name
  secret_name     = "WIF_PROVIDER"
  plaintext_value = "projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.github.workload_identity_pool_provider_id}"
}

resource "github_actions_secret" "wif_service_account" {
  repository      = local.github_repository_name
  secret_name     = "WIF_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.terraform.email
}

