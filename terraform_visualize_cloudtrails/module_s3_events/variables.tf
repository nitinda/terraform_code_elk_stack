variable common_tags {
  description = "Reource Tags"
  type = "map"
}

variable "cloudtrail_logstoelasticsearch_lambda_function_arn" {
  description = "description"
}

variable "s3_bucket_name" {
  description = "description"
}

variable depends_on { default = [], type = "list"}