resource "aws_s3_bucket_public_access_block" "demo-s3-block-public-access" {
  bucket = "${aws_s3_bucket.demo-s3.id}"

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

  depends_on = ["aws_s3_bucket_policy.demo-s3-policy","aws_s3_bucket.demo-s3"]
}