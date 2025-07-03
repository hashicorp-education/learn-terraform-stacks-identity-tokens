output "service_account_email" {
  value       = google_service_account.terraform_stacks_sa.email
  description = "Email of the service account to be used by Terraform Stacks"
}

output "jwt_audience" {
  value       = "//iam.googleapis.com/${google_iam_workload_identity_pool_provider.terraform_stacks_provider.name}"
  description = "The audience value to use when generating OIDC tokens"
}

output "gcp_project_id" {
  value       = var.gcp_project_id
  description = "GCP Project ID"
}
