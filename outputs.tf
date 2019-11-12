output "admin_group_arn" {
  value = aws_iam_group.admins.arn
}

output "admin_group_policy_name" {
  value = aws_iam_group_policy.admin.name
}
