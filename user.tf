resource "aws_iam_user" "admin" {
  name = var.admin_user_name
}

resource "aws_iam_group_membership" "admins" {
  name = "${var.admin_group_name}-group-membership"

  users = [
    "${aws_iam_user.admin.name}",
  ]

  group = "${aws_iam_group.admins.name}"
}
