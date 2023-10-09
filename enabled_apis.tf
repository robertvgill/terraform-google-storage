locals {
  services = toset([
    "storage.googleapis.com", # Cloud Storage API
  ])
}

resource "google_project_service" "service" {
  for_each = local.services

  project = var.project_id
  service = each.value
}