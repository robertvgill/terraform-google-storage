## access token
variable "google_access_token_file" {
  description = "Google Cloud access token file."
  type        = string
  sensitive   = true
}

## storage
variable "project_id" {
  description = "(Optional) The ID of the project that the service account will be created in. Defaults to the provider project configuration."
  type        = string
  default     = ""
}

variable "location_id" {
  description = "(Required) The GCS location."
  type        = string
  default     = ""
}

variable "storage_buckets" {
  description = "Creates a new bucket in Google cloud storage service (GCS)."
  default     = {}
}