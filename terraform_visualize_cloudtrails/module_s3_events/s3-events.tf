resource "aws_s3_bucket_notification" "demo-s3-bucket-notification-lambda-cloudtrail-logstoelasticsearch" {
  bucket = "${var.s3_bucket_name}"

  lambda_function {
    lambda_function_arn = "${var.cloudtrail_logstoelasticsearch_lambda_function_arn}"
    events              = ["s3:ObjectCreated:Put"]
  }
}