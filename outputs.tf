output "api_url" {
  description = "API url to consume the lambdas"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}

output "unique_identifier" {
  description = "Value of the unique identifier for the resources created"
  value       = "${var.region}-${var.workspace}-${random_uuid.name.result}"
}
