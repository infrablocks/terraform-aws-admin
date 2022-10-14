# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'
require 'base64'

describe 'user' do
  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a user' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_user')
              .with_attribute_value(:name, 'admin'))
    end

    it 'enables force destroy for the created user' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_user')
              .with_attribute_value(:name, 'admin')
              .with_attribute_value(:force_destroy, true))
    end
  end

  describe 'when admin user name provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.admin_user_name = 'admin@example.com'
      end
    end

    it 'creates a user using the specified admin user name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_user')
              .with_attribute_value(:name, 'admin@example.com'))
    end

    it 'enables force destroy for the created user' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_user')
              .with_attribute_value(:name, 'admin@example.com')
              .with_attribute_value(:force_destroy, true))
    end
  end

  describe 'when login profile included' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.admin_user_password_length = 48
        vars.include_login_profile = true
      end
    end

    it 'creates a login profile for the user' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_user_login_profile')
              .with_attribute_value(:user, 'admin'))
    end

    it 'uses the specified password length' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_user_login_profile')
              .with_attribute_value(:user, 'admin')
              .with_attribute_value(:password_length, 48))
    end

    it 'uses the specified public GPG key' do
      public_gpg_key_path = var(role: :root, name: 'admin_public_gpg_key_path')
      public_gpg_key = Base64.strict_encode64(File.read(public_gpg_key_path))

      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_user_login_profile')
              .with_attribute_value(:user, 'admin')
              .with_attribute_value(:pgp_key, public_gpg_key))
    end
  end

  describe 'when login profile not included' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.admin_user_password_length = 48
        vars.include_login_profile = false
      end
    end

    it 'does not create a login profile for the user' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_iam_user_login_profile')
                  .with_attribute_value(:user, 'admin'))
    end
  end

  describe 'when access key included' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_access_key = true
      end
    end

    it 'creates an access key for the user' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_access_key')
              .with_attribute_value(:user, 'admin'))
    end

    it 'uses the specified public GPG key' do
      public_gpg_key_path = var(role: :root, name: 'admin_public_gpg_key_path')
      public_gpg_key = Base64.strict_encode64(File.read(public_gpg_key_path))

      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_access_key')
              .with_attribute_value(:user, 'admin')
              .with_attribute_value(:pgp_key, public_gpg_key))
    end
  end

  describe 'when access key not included' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_access_key = false
      end
    end

    it 'does not create an access key for the user' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_iam_access_key')
                  .with_attribute_value(:user, 'admin'))
    end
  end
end
