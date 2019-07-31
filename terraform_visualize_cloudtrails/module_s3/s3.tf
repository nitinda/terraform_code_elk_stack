resource "aws_s3_bucket" "demo-s3" {
  bucket = "terraform-demo-${data.aws_caller_identity.demo-current.account_id}-s3-cloudtrail-logging"
  region = "eu-central-1"
  acl    = "private"

  # Everything in the log bucket rotates to infrequent access and expires.
  lifecycle_rule {
    id      = "MultipartUpload_LifecycleRule"
    prefix  = ""
    enabled = true

    # Multi Part Upload
    abort_incomplete_multipart_upload_days = "1"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Enabling versioning protects against accidental deletes.
  versioning {
    enabled = false
  }

  # A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error
  force_destroy = true

  tags = "${var.common_tags}"
}