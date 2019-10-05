output "website_url" {
  description = "URL of the website"
  value       = module.www_site.website_url
}

output "website_bucket" {
  description = "Self link to the website bucket"
  value       = module.www_site.website_bucket
}

output "website_bucket_name" {
  description = "Name of the website bucket"
  value       = module.www_site.website_bucket_name
}