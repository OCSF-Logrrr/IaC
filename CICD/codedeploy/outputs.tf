#outputs.tf

output "codedeploy_app_arn" { 
  value       = aws_codedeploy_app.codedeploy_app.arn
  description = "codedeploy_app_arn"
}

output "codedeploy_group_arn" { 
  value       = aws_codedeploy_deployment_group.codedeploy_group.arn
  description = "codedeploy_group_arn"
}

output "codedeploy_app_id" { 
  value       = aws_codedeploy_app.codedeploy_app.application_id
  description = "codedeploy_app_id"
}

output "codedeploy_deployment_group_id" { 
  value       = aws_codedeploy_deployment_group.codedeploy_group.deployment_group_id
  description = "codedeploy_deployment_group_id"
}

output "codedeploy_id" { 
  value       = aws_codedeploy_deployment_group.codedeploy_group.id
  description = "codedeploy_id"
}

# output "codedeploy_app_name" { 
#   value       = aws_codedeploy_app.codedeploy_app.name
#   description = "codedeploy_app_name"
# }