locals {
  workstation-external-cidr = "${chomp(data.http.demo-workstation-external-ip.body)}/32"
}

locals {
  Project = "ELK POC"
  Owner   = "Platform Team"
  Environment = "prod"
  BusinessUnit = "Platform Team"
}

variable common_tags {
  description = "Reource Tags"
  type = "map"
}