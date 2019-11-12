resource "aws_iam_group" "admins" {
  name = var.admin_group_name
}

data "aws_iam_policy_document" "admin" {
  statement {
    effect = "Allow"

    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "admin" {
  group = var.admin_group_name
  policy = coalesce(var.admin_group_policy_contents, data.aws_iam_policy_document.admin.json)
}
