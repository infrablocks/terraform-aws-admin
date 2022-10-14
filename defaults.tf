locals {
  # default for cases when `null` value provided, meaning "use default"
  admin_user_name = var.admin_user_name == null ? "admin" : var.admin_user_name
  admin_group_name = var.admin_group_name == null ? "admins" : var.admin_group_name
  admin_group_policy_contents = var.admin_group_policy_contents == null ? "" : var.admin_group_policy_contents
  admin_user_password_length = var.admin_user_password_length == null ? 32 : var.admin_user_password_length
  admin_public_gpg_key = var.admin_public_gpg_key == null ? "" : var.admin_public_gpg_key
  include_login_profile = var.include_login_profile == null ? true : var.include_login_profile
  include_access_key = var.include_access_key == null ? true : var.include_access_key
}
