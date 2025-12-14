output "repositories" {
  value = {
    for name, repo in module.repositories : name => {
      name           = repo.repository_name
      full_name      = repo.repository_full_name
      http_clone_url = repo.repository_http_clone_url
      rulesets       = repo.rulesets
    }
  }
  description = "Map of all repositories with their details"
}
