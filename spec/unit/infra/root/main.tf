data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "admin" {
  source = "../../../.."

  admin_user_name = var.admin_user_name
  admin_group_name = var.admin_group_name

  admin_group_policy_contents = var.admin_group_policy_contents

  admin_user_password_length = var.admin_user_password_length

  admin_public_gpg_key = filebase64(var.admin_public_gpg_key_path)

  include_login_profile = var.include_login_profile
  include_access_key = var.include_access_key
}
