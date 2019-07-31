variable "vpc_zone_identifier" {
  type = "list"
  description = ""
}

variable "vpc_security_group_ids" {
  description = ""
}

variable "public_subnets" {
  description = "description"
  type = "list"
}


variable common_tags {
  description = "Reource Tags"
  type = "map"
}

#### ALB

variable "acm_domain_name" {
  description = "description"
}

variable "vpc_id" {
  description = "description"
}

# data "aws_acm_certificate" "demo-acm-certificate" {
#   statuses = ["ISSUED"]
#   types    = ["AMAZON_ISSUED"]
#   domain   = "${var.acm_domain_name}"
# }

