resource "aws_cloudwatch_log_group" "demo-cloudtrail-cloudwatch-log-group" {
    name = "terraform-demo-cloudtrail-cw-log-group"
    retention_in_days = 90

    tags = "${var.common_tags}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_cloudwatch_log_group" "demo-vpc-flowlog-cloudwatch-loggroup" {
    name = "terraform-demo-vpc-flowlog-cw-loggroup"
    retention_in_days = 90

    tags = "${var.common_tags}"
    lifecycle {
        create_before_destroy = true
    }
}