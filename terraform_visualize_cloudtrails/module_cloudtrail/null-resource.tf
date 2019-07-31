resource "null_resource" "demo-delay" {
  provisioner "local-exec" {
    command = "sleep 10"
  }
}