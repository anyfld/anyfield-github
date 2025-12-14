output "repository_name" {
  value       = github_repository.this.name
  description = "The name of the repository"
}

output "repository_full_name" {
  value       = github_repository.this.full_name
  description = "The full name of the repository (owner/repo)"
}

output "repository_html_url" {
  value       = github_repository.this.html_url
  description = "The HTML URL of the repository"
}

output "repository_ssh_clone_url" {
  value       = github_repository.this.ssh_clone_url
  description = "The SSH clone URL of the repository"
}

output "repository_http_clone_url" {
  value       = github_repository.this.http_clone_url
  description = "The HTTP clone URL of the repository"
}

output "repository_git_clone_url" {
  value       = github_repository.this.git_clone_url
  description = "The Git clone URL of the repository"
}

output "repository_id" {
  value       = github_repository.this.repo_id
  description = "The ID of the repository"
}

output "repository_node_id" {
  value       = github_repository.this.node_id
  description = "The Node ID of the repository"
}

output "default_branch" {
  value       = github_branch_default.this.branch
  description = "The name of the default branch"
}

output "rulesets" {
  value = {
    for name, ruleset in github_repository_ruleset.this : name => {
      id          = ruleset.id
      node_id     = ruleset.node_id
      name        = ruleset.name
      enforcement = ruleset.enforcement
    }
  }
  description = "Map of repository rulesets with their IDs and enforcement status"
}
