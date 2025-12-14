variable "repositories" {
  type = any
  default = {
    "anyfield-github" = {
      ruleset_presets = ["main_branch_protection"]
    }
  }
}

module "repositories" {
  source   = "./modules/github-repository"
  for_each = local.repositories

  name        = each.value.name
  description = each.value.description
  visibility  = each.value.visibility

  has_issues      = each.value.has_issues
  has_discussions = each.value.has_discussions
  has_projects    = each.value.has_projects
  has_wiki        = each.value.has_wiki

  delete_branch_on_merge = each.value.delete_branch_on_merge
  allow_merge_commit     = each.value.allow_merge_commit
  allow_squash_merge     = each.value.allow_squash_merge
  allow_rebase_merge     = each.value.allow_rebase_merge
  allow_auto_merge       = each.value.allow_auto_merge

  default_branch     = each.value.default_branch
  archive_on_destroy = each.value.archive_on_destroy

  vulnerability_alerts = each.value.vulnerability_alerts
  topics               = each.value.topics
  homepage_url         = each.value.homepage_url

  rulesets = each.value.rulesets
}
