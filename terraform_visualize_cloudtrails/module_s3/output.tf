output "s3_bucket_arn" {
  value = "${aws_s3_bucket.demo-s3.arn}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.demo-s3.id}"
}

output "s3_block_public_access_id" {
  value = "${aws_s3_bucket_public_access_block.demo-s3-block-public-access.id}"
}