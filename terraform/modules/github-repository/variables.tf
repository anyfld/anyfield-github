variable "name" {
  type        = string
  description = "The name of the repository"
}

variable "description" {
  type        = string
  default     = ""
  description = "A description of the repository"
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "The visibility of the repository. Can be public, private, or internal"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Visibility must be one of: public, private, internal."
  }
}

variable "has_issues" {
  type        = bool
  default     = true
  description = "Set to true to enable the GitHub Issues features on the repository"
}

variable "has_discussions" {
  type        = bool
  default     = false
  description = "Set to true to enable GitHub Discussions on the repository"
}

variable "has_projects" {
  type        = bool
  default     = false
  description = "Set to true to enable the GitHub Projects features on the repository"
}

variable "has_wiki" {
  type        = bool
  default     = false
  description = "Set to true to enable the GitHub Wiki features on the repository"
}

variable "delete_branch_on_merge" {
  type        = bool
  default     = true
  description = "Automatically delete head branch after a pull request is merged"
}

variable "allow_merge_commit" {
  type        = bool
  default     = true
  description = "Set to false to disable merge commits on the repository"
}

variable "allow_squash_merge" {
  type        = bool
  default     = true
  description = "Set to false to disable squash merges on the repository"
}

variable "allow_rebase_merge" {
  type        = bool
  default     = true
  description = "Set to false to disable rebase merges on the repository"
}

variable "allow_auto_merge" {
  type        = bool
  default     = false
  description = "Set to true to allow auto-merging pull requests on the repository"
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The name of the default branch of the repository"
}

variable "archive_on_destroy" {
  type        = bool
  default     = false
  description = "Specifies if the repository should be archived instead of deleted on destroy"
}

variable "rulesets" {
  type        = list(object({
    name        = string
    target      = string
    enforcement = string

    include_refs = optional(list(string), ["~DEFAULT_BRANCH"])
    exclude_refs = optional(list(string), [])

    bypass_actors = optional(list(object({
      actor_id    = number
      actor_type  = string
      bypass_mode = string
    })), [])

    rules = object({
      creation                      = optional(bool, false)
      deletion                      = optional(bool, true)
      non_fast_forward              = optional(bool, true)
      required_linear_history       = optional(bool, false)
      required_signatures           = optional(bool, false)
      update                        = optional(bool, false)
      update_allows_fetch_and_merge = optional(bool, false)

      pull_request = optional(object({
        dismiss_stale_reviews_on_push     = optional(bool, true)
        require_code_owner_review         = optional(bool, false)
        require_last_push_approval        = optional(bool, false)
        required_approving_review_count   = optional(number, 1)
        required_review_thread_resolution = optional(bool, true)
      }), null)

      required_status_checks = optional(object({
        strict_required_status_checks_policy = optional(bool, false)
        required_checks = optional(list(object({
          context        = string
          integration_id = optional(number)
        })), [])
      }), null)
    })
  }))
  default     = []
  description = "List of repository rulesets to apply to the repository"
}

variable "topics" {
  type        = list(string)
  default     = []
  description = "The list of topics of the repository"
}

variable "homepage_url" {
  type        = string
  default     = ""
  description = "URL of a page describing the project"
}

variable "vulnerability_alerts" {
  type        = bool
  default     = true
  description = "Set to true to enable security alerts for vulnerable dependencies"
}
