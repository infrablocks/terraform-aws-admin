resource "aws_iam_user" "admin" {
  name = local.admin_user_name
  force_destroy = true
}

resource "aws_iam_group_membership" "admins" {
  name = "${local.admin_group_name}-group-membership"

  users = [
    aws_iam_user.admin.name,
  ]

  group = aws_iam_group.admins.name
}

resource "aws_iam_user_login_profile" "admin" {
  count = local.include_login_profile ? 1 : 0

  user = aws_iam_user.admin.name
  pgp_key = local.admin_public_gpg_key
  password_length = local.admin_user_password_length
}

resource "aws_iam_access_key" "admin" {
  count = local.include_access_key ? 1 : 0

  user = aws_iam_user.admin.name
  pgp_key = local.admin_public_gpg_key
}
