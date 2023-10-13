provider "google" {
  project = var.project_id
  region  = var.location_id

  # More information on the authentication methods supported by
  # the Google Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs
}