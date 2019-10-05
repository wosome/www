provider "google-beta" {
  project = var.project
  region = var.region
  zone = var.zone
}

terraform {
  backend "gcs" {
    bucket = "wosome-tf"
  }
}

module "www_site" {
  source = "./www"
  project = var.project

  cors_methods = ["GET", "POST", "PUT", "OPTIONS"]
  cors_origins = ["*"]
  cors_max_age_seconds = "86400"
  cors_extra_headers = ["ContentType", "Authorization"]
  website_domain_name = var.website_domain_name
  create_dns_entry = true
  enable_versioning = true
  dns_managed_zone_name = var.dns_managed_zone_name

  index_page = var.index_page
  not_found_page = var.not_found_page
}


resource "google_storage_bucket_object" "index" {
  name    = var.index_page
  content = "Hello, World!"
  bucket  = module.www_site.website_bucket_name
}


resource "google_storage_bucket_object" "not_found" {
  name    = var.not_found_page
  content = "Uh oh"
  bucket  = module.www_site.website_bucket_name
}

resource "google_storage_object_acl" "index_acl" {
  bucket      = module.www_site.website_bucket_name
  object      = google_storage_bucket_object.index.name
  role_entity = ["READER:allUsers"]
}

resource "google_storage_object_acl" "not_found_acl" {
  bucket      = module.www_site.website_bucket_name
  object      = google_storage_bucket_object.not_found.name
  role_entity = ["READER:allUsers"]
}