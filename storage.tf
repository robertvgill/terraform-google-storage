/**
resource "random_id" "bucket_suffix" {
  count = var.randomize_suffix ? 1 : 0

  byte_length = 5
}
**/
resource "google_storage_bucket" "buckets" {
  for_each = {
    for k, v in var.storage_buckets : k => v
    if v.create
  }

  //  name                        = substr(join("-", compact([each.key, var.randomize_suffix ? random_id.bucket_suffix[0].hex : ""])), 0, 63)
  name                        = substr(join("-", compact([format("%s", var.project_id), "gs", format("%s", each.key)])), 0, 50)
  force_destroy               = lookup(each.value, "force_destroy", null)
  location                    = format("%s", var.location_id)
  project                     = format("%s", var.project_id)
  storage_class               = lookup(each.value, "storage_class", null)
  labels                      = lookup(each.value, "labels", null)
  requester_pays              = lookup(each.value, "requester_pays", null)
  uniform_bucket_level_access = lookup(each.value, "uniform_bucket_level_access", null)

  dynamic "lifecycle_rule" {
    for_each = {
      for k, v in var.storage_buckets : k => v
      if contains(keys(v), "lifecycle_rule")
    }

    content {
      action {
        type          = try(each.value.lifecycle_rule.action.type, null)
        storage_class = each.value.lifecycle_rule.action.type == "SetStorageClass" ? each.value.lifecycle_rule.action.storage_class : null
      }
      condition {
        age                        = try(each.value.lifecycle_rule.condition.age, null)
        created_before             = try(each.value.lifecycle_rule.condition.created_before, null)
        with_state                 = try(each.value.lifecycle_rule.condition.with_state, null)
        matches_storage_class      = try(each.value.lifecycle_rule.condition.matches_storage_class, null)
        num_newer_versions         = try(each.value.lifecycle_rule.condition.num_newer_versions, null)
        custom_time_before         = try(each.value.lifecycle_rule.condition.custom_time_before, null)
        days_since_custom_time     = try(each.value.lifecycle_rule.condition.days_since_custom_time, null)
        days_since_noncurrent_time = try(each.value.lifecycle_rule.condition.days_since_noncurrent_time, null)
        noncurrent_time_before     = try(each.value.lifecycle_rule.condition.noncurrent_time_before, null)
      }
    }
  }

  versioning {
    enabled = each.value.versioning.enabled
  }

  dynamic "website" {
    for_each = {
      for k, v in var.storage_buckets : k => v
      if contains(keys(v), "website")
    }

    content {
      main_page_suffix = try(each.value.website.main_page_suffix, null)
      not_found_page   = try(each.value.website.not_found_page, null)
    }
  }

  dynamic "cors" {
    for_each = {
      for k, v in var.storage_buckets : k => v
      if contains(keys(v), "cors")
    }

    content {
      origin          = try(each.value.cors.origin, null)
      method          = try(each.value.cors.method, null)
      response_header = try(each.value.cors.response_header, null)
      max_age_seconds = try(each.value.cors.max_age_seconds, null)
    }
  }

  dynamic "retention_policy" {
    for_each = {
      for k, v in var.storage_buckets : k => v
      if contains(keys(v), "retention_policy")
    }

    content {
      retention_period = try(each.value.retention_policy.retention_period, null)
      is_locked        = try(each.value.retention_policy.is_locked, null)
    }
  }

  dynamic "logging" {
    for_each = {
      for k, v in var.storage_buckets : k => v
      if contains(keys(v), "logging")
    }

    content {
      log_bucket        = try(each.value.logging.log_bucket, null)
      log_object_prefix = try(each.value.logging.log_object_prefix, null)
    }
  }

  dynamic "encryption" {
    for_each = {
      for k, v in var.storage_buckets : k => v
      if contains(keys(v), "encryption")
    }

    content {
      default_kms_key_name = try(each.value.encryption.default_kms_key_name, null)
    }
  }
}