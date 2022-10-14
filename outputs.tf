output "admin_user_arn" {
  value = aws_iam_user.admin.arn
}

output "admin_user_name" {
  value = local.admin_user_name
}

output "admin_user_password" {
  value = element(concat(aws_iam_user_login_profile.admin.*.encrypted_password, [""]), 0)
}

output "admin_user_access_key_id" {
  value = element(concat(aws_iam_access_key.admin.*.id, [""]), 0)
}

output "admin_user_secret_access_key" {
  value = element(concat(aws_iam_access_key.admin.*.encrypted_secret, [""]), 0)
}

output "admin_group_arn" {
  value = aws_iam_group.admins.arn
}

output "admin_group_policy_name" {
  value = aws_iam_group_policy.admin.name
}
