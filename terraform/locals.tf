locals {
  github_owner           = "anyfld"
  github_repository_name = "anyfield-github"

  gcp_project_id  = "anyfield"
  gcp_region      = "us-central1"
  gcs_bucket_name = "anyfield-github-terraform"

  repositories_config = {
    "anyfield-github" = {
      visibility      = "public"
      ruleset_presets = ["main_branch_protection"]
    }
    "vistra-schema" = {
      visibility      = "public"
      ruleset_presets = ["main_branch_protection"]
    }
    "vistra-operation-control-room" = {
      visibility      = "public"
      ruleset_presets = ["main_branch_protection"]
    }
    "vistra-infra" = {
      visibility      = "public"
      ruleset_presets = ["main_branch_protection"]
    }
    "vistra-exective-producer" = {
      visibility      = "public"
      ruleset_presets = ["main_branch_protection"]
    }
    "vistra-camera-operator" = {
      visibility      = "public"
      ruleset_presets = ["main_branch_protection"]
    }
    "vistra-director" = {
      visibility      = "public"
      ruleset_presets = ["main_branch_protection"]
    }
  }

  repository_defaults = {
    description            = ""
    visibility             = "private"
    has_issues             = true
    has_discussions        = false
    has_projects           = false
    has_wiki               = false
    delete_branch_on_merge = true
    allow_merge_commit     = false
    allow_squash_merge     = true
    allow_rebase_merge     = false
    allow_auto_merge       = true
    default_branch         = "main"
    archive_on_destroy     = false
    vulnerability_alerts   = true
    topics                 = []
    homepage_url           = ""
    rulesets               = []
  }

  ruleset_presets = {
    main_branch_protection = {
      name         = "main branch protect"
      target       = "branch"
      enforcement  = "active"
      include_refs = ["~DEFAULT_BRANCH"]
      exclude_refs = []
      bypass_actors = [
        {
          actor_id    = 5
          actor_type  = "RepositoryRole"
          bypass_mode = "pull_request"
        }
      ]
      rules = {
        creation                      = true
        deletion                      = true
        non_fast_forward              = true
        required_linear_history       = true
        required_signatures           = true
        update                        = false
        update_allows_fetch_and_merge = false
        pull_request = {
          dismiss_stale_reviews_on_push     = false
          require_code_owner_review         = false
          require_last_push_approval        = false
          required_approving_review_count   = 0
          required_review_thread_resolution = true
        }
        required_status_checks = {
          strict_required_status_checks_policy = false
          required_checks = [
            { context = "all-status-check", integration_id = 15368 },
            { context = "validate-pull-request", integration_id = 15368 },
          ]
        }
      }
    }
  }

  repositories = {
    for name, config in local.repositories_config : name => merge(
      local.repository_defaults,
      config,
      {
        name = name
        rulesets = flatten([
          for preset in lookup(config, "ruleset_presets", []) :
          [local.ruleset_presets[preset]]
        ])
      }
    )
  }
}
