Terraform AWS Admin
===================

[![CircleCI](https://circleci.com/gh/infrablocks/terraform-aws-admin.svg?style=svg)](https://circleci.com/gh/infrablocks/terraform-aws-admin)

A Terraform module for managing an admin user and group.

The admin deployment has no requirements.

The admin deployment consists of:

* an admin user
  * with an optional login profile
  * with an optional access key
* an admins group
  * with an associated policy allowing admin access

Usage
-----

To use the module, include something like the following in your Terraform
configuration:

```hcl-terraform
module "admin" {
  source  = "infrablocks/admin/aws"
  version = "2.0.0"

  admin_user_name  = "administrator"
  admin_group_name = "administrators"

  admin_public_gpg_key = filebase64("${path.root}/keys/admin.gpg")

  admin_user_password_length = 48
}
```

See the
[Terraform registry entry](https://registry.terraform.io/modules/infrablocks/admin/aws/latest)
for more details.

### Inputs

| Name                        | Description                                                                                                                                     | Default  |           Required           |
|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|:----------------------------:|
| admin_user_name             | The name of the admin user.                                                                                                                     | "admin"  |              no              |
| admin_group_name            | The name of the admins group.                                                                                                                   | "admins" |              no              |
| admin_group_policy_contents | The contents of the policy associated with the admins group. By default, full access is granted.                                                |    ""    |              no              |
| admin_public_gpg_key        | The contents of the public GPG key for the admin, base 64 encoded. Only required if `include_login_profile` or `include_access_key` are `true`. |    -     | yes, depending on other vars |
| admin_user_password_length  | The length of the admin user password to create. Only relevant if `include_login_profile` is `true`.                                            |    32    |              no              |
| include_login_profile       | Whether or not to generate a login profile for the admin user. Uses the provided admin GPG key to encrypt the credentials. Defaults to `true`.  |   true   |              no              |
| include_access_key          | Whether or not to generate an access key for the admin user. Uses the provided admin GPG key to encrypt the credentials. Defaults to `true`.    |   true   |              no              |

### Outputs

| Name                         | Description                                                                                                                                                                           |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| admin_user_arn               | The ARN of the managed admin user.                                                                                                                                                    |
| admin_user_name              | The name of the managed admin user.                                                                                                                                                   |
| admin_user_password          | The password of the managed admin user, base64 encoded and encrypted using the provided admin public GPG key. When `include_login_profile` is `false`, this is an empty string.       |
| admin_user_access_key_id     | The access key ID of the managed admin user. When `include_access_key` is `false`, this is an empty string.                                                                           |
| admin_user_secret_access_key | The secret access key of the managed admin user, base64 encoded and encrypted using the provided admin public GPG key. When `include_access_key` is `false`, this is an empty string. |
| admin_group_arn              | The ARN of the managed admins group.                                                                                                                                                  |
| admin_group_policy_name      | The name of the policy attached to the managed admins group.                                                                                                                          |

### Compatibility

This module is compatible with Terraform versions greater than or equal to
Terraform 1.0.

Development
-----------

### Machine Requirements

In order for the build to run correctly, a few tools will need to be installed
on your development machine:

* Ruby (3.1)
* Bundler
* git
* git-crypt
* gnupg
* direnv
* aws-vault

#### Mac OS X Setup

Installing the required tools is best managed by [homebrew](http://brew.sh).

To install homebrew:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then, to install the required tools:

```
# ruby
brew install rbenv
brew install ruby-build
echo 'eval "$(rbenv init - bash)"' >> ~/.bash_profile
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
eval "$(rbenv init -)"
rbenv install 3.1.1
rbenv rehash
rbenv local 3.1.1
gem install bundler

# git, git-crypt, gnupg
brew install git
brew install git-crypt
brew install gnupg

# aws-vault
brew cask install

# direnv
brew install direnv
echo "$(direnv hook bash)" >> ~/.bash_profile
echo "$(direnv hook zsh)" >> ~/.zshrc
eval "$(direnv hook $SHELL)"

direnv allow <repository-directory>
```

### Running the build

Running the build requires an AWS account and AWS credentials. You are free to
configure credentials however you like as long as an access key ID and secret
access key are available. These instructions utilise
[aws-vault](https://github.com/99designs/aws-vault) which makes credential
management easy and secure.

To run the full build, including unit and integration tests, execute:

```bash
aws-vault exec <profile> -- ./go
```

To run the unit tests, execute:

```bash
aws-vault exec <profile> -- ./go test:unit
```

To run the integration tests, execute:

```bash
aws-vault exec <profile> -- ./go test:integration
```

To provision the module prerequisites:

```bash
aws-vault exec <profile> -- ./go deployment:prerequisites:provision[<deployment_identifier>]
```

To provision the module contents:

```bash
aws-vault exec <profile> -- ./go deployment:root:provision[<deployment_identifier>]
```

To destroy the module contents:

```bash
aws-vault exec <profile> -- ./go deployment:root:destroy[<deployment_identifier>]
```

To destroy the module prerequisites:

```bash
aws-vault exec <profile> -- ./go deployment:prerequisites:destroy[<deployment_identifier>]
```

Configuration parameters can be overridden via environment variables. For
example, to run the unit tests with a seed of `"testing"`, execute:

```bash
SEED=testing aws-vault exec <profile> -- ./go test:unit
```

When a seed is provided via an environment variable, infrastructure will not be
destroyed at the end of test execution. This can be useful during development
to avoid lengthy provision and destroy cycles.

To subsequently destroy unit test infrastructure for a given seed:

```bash
FORCE_DESTROY=yes SEED=testing aws-vault exec <profile> -- ./go test:unit
```

### Common Tasks

#### Generating an SSH key pair

To generate an SSH key pair:

```
ssh-keygen -m PEM -t rsa -b 4096 -C integration-test@example.com -N '' -f config/secrets/keys/bastion/ssh
```

#### Generating a self-signed certificate

To generate a self signed certificate:

```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
```

To decrypt the resulting key:

```
openssl rsa -in key.pem -out ssl.key
```

#### Managing CircleCI keys

To encrypt a GPG key for use by CircleCI:

```bash
openssl aes-256-cbc \
  -e \
  -md sha1 \
  -in ./config/secrets/ci/gpg.private \
  -out ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

To check decryption is working correctly:

```bash
openssl aes-256-cbc \
  -d \
  -md sha1 \
  -in ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

Contributing
------------

Bug reports and pull requests are welcome on GitHub at
https://github.com/infrablocks/terraform-aws-admin.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
-------

The library is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
