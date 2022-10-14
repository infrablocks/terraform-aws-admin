variable "admin_user_name" {
  type        = string
  default     = "admin"
  description = "The name of the admin user to create. Defaults to 'admin'."
}

variable "admin_group_name" {
  type        = string
  default     = "admins"
  description = "The name of the admin group to create. Defaults to 'admins'."
}

variable "admin_group_policy_contents" {
  type        = string
  default     = ""
  description = "The contents of the admin group policy. Defaults to full access."
}

variable "admin_public_gpg_key" {
  type        = string
  default     = ""
  description = "The contents of the public GPG key for the admin, base 64 encoded. Only required if 'include_login_profile' or 'include_access_key' are true."
}

variable "admin_user_password_length" {
  type        = number
  default     = 32
  description = "The length of the admin user password to create. Only required if 'include_login_profile' is true."
}

variable "include_login_profile" {
  type        = bool
  default     = true
  description = "Whether or not to generate a login profile for the admin user. Uses the provided admin GPG key to encrypt the credentials. Defaults to true."
}

variable "include_access_key" {
  type        = bool
  default     = true
  description = "Whether or not to generate an access key for the admin user. Uses the provided admin GPG key to encrypt the credentials. Defaults to true."
}
