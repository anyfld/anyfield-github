resource "github_team" "vistra_developer" {
  name        = "vistra-developer"
  description = "Team for Vistra project developers"
  privacy     = "closed"
}

resource "github_team_membership" "vistra_developer_members" {
  for_each = toset([
    "5ouma",
    "shiron-dev",
    "kokokoko0825"
  ])

  team_id  = github_team.vistra_developer.id
  username = each.value
  role     = "member"
}

resource "github_team_repository" "vistra_repositories" {
  for_each = toset([
    "vistra-schema",
    "vistra-operation-control-room",
    "vistra-infra",
    "vistra-exective-producer",
    "vistra-camera-operator",
    "vistra-director"
  ])

  team_id    = github_team.vistra_developer.id
  repository = each.value
  permission = "maintain"
}

