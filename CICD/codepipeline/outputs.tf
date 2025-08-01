#outputs.tf

output "pipeline_id" { 
  value       = aws_codepipeline.pipeline.id
  description = "Codepipeline ID"
}

output "pipeline_name" { 
  value       = aws_codepipeline.pipeline.name
  description = "Codepipeline name"
}

output "pipeline_role_arn" { 
  value       = aws_iam_role.pipeline_role.arn
  description = "Codepipeline Role ARN"
}

output "pipeline_role_name" { 
  value       = aws_iam_role.pipeline_role.name
  description = "Codepipeline Role name"
}

output "pipeline_policy_arn" { 
  value       = aws_iam_policy.pipeline_policy.arn
  description = "Codepipeline Policy ARN"
}

output "codebuild_s3_name" {
  value       = aws_s3_bucket.codebuild_s3.bucket
  description = "CodeBuild S3 bucket Name"
}

output "codebuild_s3_id" {
  value       = aws_s3_bucket.codebuild_s3.id
  description = "CodeBuild S3 bucket ID"
}

output "codebuild_s3_arn" {
  value       = aws_s3_bucket.codebuild_s3.arn
  description = "CodeBuild S3 bucket ARN"
}