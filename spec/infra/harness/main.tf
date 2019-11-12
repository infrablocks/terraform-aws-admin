data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "admin" {
  source = "../../../../"

  admin_user_name = var.admin_user_name
  admin_group_name = var.admin_group_name
}
