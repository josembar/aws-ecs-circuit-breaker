resource "terraform_data" "build" {
  provisioner "local-exec" {
    command = "./build-and-push-images.sh ${data.aws_region.current.name} ${data.aws_caller_identity.current.account_id} ${local.nodejs_image_name} ${local.java_image_name} ${local.app_prefix}"
  }
  depends_on = [aws_ecr_repository.this]
}