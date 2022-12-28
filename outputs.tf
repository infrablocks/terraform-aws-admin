output "admin_user_arn" {
  description = "The ARN of the managed admin user."
  value = aws_iam_user.admin.arn
}

output "admin_user_name" {
  description = "The name of the managed admin user."
  value = local.admin_user_name
}

output "admin_user_password" {
  description = "The password of the managed admin user, base64 encoded and encrypted using the provided admin public GPG key."
  value = element(concat(aws_iam_user_login_profile.admin.*.encrypted_password, [""]), 0)
}

output "admin_user_access_key_id" {
  description = "The access key ID of the managed admin user."
  value = element(concat(aws_iam_access_key.admin.*.id, [""]), 0)
}

output "admin_user_secret_access_key" {
  description = "The secret access key of the managed admin user, base64 encoded and encrypted using the provided admin public GPG key."
  value = element(concat(aws_iam_access_key.admin.*.encrypted_secret, [""]), 0)
}

output "admin_group_arn" {
  description = "The ARN of the managed admins group."
  value = aws_iam_group.admins.arn
}

output "admin_group_policy_name" {
  description = "The name of the policy attached to the managed admins group."
  value = aws_iam_group_policy.admin.name
}
