variable "region" {}

variable "admin_user_name" {
  type = string
  default = null
}
variable "admin_group_name" {
  type = string
  default = null
}

variable "admin_group_policy_contents" {
  type    = string
  default = null
}

variable "admin_public_gpg_key_path" {}

variable "admin_user_password_length" {
  type = number
  default = null
}
variable "enforce_mfa" {
  type = string
  default = null
}
variable "include_login_profile" {
  type = string
  default = null
}
variable "include_access_key" {
  type = string
  default = null
}
