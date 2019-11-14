resource "aws_iam_user" "admin" {
  name = var.admin_user_name
}

resource "aws_iam_group_membership" "admins" {
  name = "${var.admin_group_name}-group-membership"

  users = [
    aws_iam_user.admin.name,
  ]

  group = aws_iam_group.admins.name
}

resource "aws_iam_user_login_profile" "admin" {
  count = var.include_login_profile ? 1 : 0

  user = aws_iam_user.admin.name
  pgp_key = var.admin_public_gpg_key
  password_length = var.admin_user_password_length
}
