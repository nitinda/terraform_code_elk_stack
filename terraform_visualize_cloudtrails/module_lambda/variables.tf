variable "cognito_user_pool_id" {
  description = "description"
}

variable "es_endpoint" {
  description = "description"
}

# variable "cloud_watch_logs_group_arn_cloudtrail" {
#   description = "description"
# }

# variable "cloud_watch_logs_role_arn" {
#   description = "description"
# }

variable "cloud_watch_logs_group_arn_vpcflow" {
  description = "description"
}

variable depends_on { default = [], type = "list"}

variable "lambda_layer_python_arn" {
  description = "The Amazon Resource Name (ARN) of the Lambda Layer with version"  
}

variable common_tags {
  description = "Reource Tags"
  type = "map"
}

variable "s3_bucket_name" {
  description = "description"
}

variable "s3_bucket_arn" {
  description = "description"
}
