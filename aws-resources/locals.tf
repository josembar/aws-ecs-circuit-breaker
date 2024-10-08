locals {
  app_prefix        = "circuit-breaker-demo"
  nodejs_image_name = "nodejsapp"
  java_image_name   = "javaapp"
  app_port          = 3000
  app_path          = "hello"
  image_tag         = "latest"
  ecr_definition = {
    "${local.app_prefix}-nodejs" = {
      name                 = "${local.app_prefix}-nodejs"
      image_tag_mutability = "MUTABLE"
      force_delete         = true
      scan_on_push         = false
    },
    "${local.app_prefix}-java" = {
      name                 = "${local.app_prefix}-java"
      image_tag_mutability = "MUTABLE"
      force_delete         = true
      scan_on_push         = false
    }
  }
}