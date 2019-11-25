variable "admin_user_name" {
  default = "admin"
  type = string
  description = "The name of the admin user to create. Defaults to 'admin'."
}

variable "admin_group_name" {
  default = "admins"
  type = string
  description = "The name of the admin group to create. Defaults to 'admins'."
}

variable "admin_group_policy_contents" {
  default = ""
  type = string
  description = "The contents of the admin group policy. Defaults to full access."
}

variable "admin_public_gpg_key" {
  type = string
  default = ""
  description = "The contents of the public GPG key for the admin, base 64 encoded. Only required if 'include_login_profile' or 'include_access_key' are true."
}

variable "admin_user_password_length" {
  type = number
  default = 32
  description = "The length of the admin user password to create. Only required if 'include_login_profile' is true."
}

variable "include_login_profile" {
  default = true
  type = bool
  description = "Whether or not to generate a login profile for the admin user. Uses the provided admin GPG key to encrypt the credentials. Defaults to true."
}

variable "include_access_key" {
  default = true
  type = bool
  description = "Whether or not to generate an access key for the admin user. Uses the provided admin GPG key to encrypt the credentials. Defaults to true."
}
