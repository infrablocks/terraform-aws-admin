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
