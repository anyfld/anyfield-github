output "repository_name" {
  value = github_repository.this.name
}

output "repository_full_name" {
  value = github_repository.this.full_name
}

output "repository_html_url" {
  value = github_repository.this.html_url
}

output "repository_ssh_clone_url" {
  value = github_repository.this.ssh_clone_url
}

output "repository_http_clone_url" {
  value = github_repository.this.http_clone_url
}

output "repository_git_clone_url" {
  value = github_repository.this.git_clone_url
}

output "repository_id" {
  value = github_repository.this.repo_id
}

output "repository_node_id" {
  value = github_repository.this.node_id
}

output "default_branch" {
  value = github_branch_default.this.branch
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
}
