# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  let(:account_id) { account.account }

  let(:deployment_identifier) do
    var(role: :full, name: 'deployment_identifier')
  end

  let(:gpg_key_passphrase) do
    File.read('config/secrets/admin/gpg.passphrase')
  rescue StandardError
    nil
  end

  let(:private_gpg_key) do
    File.read('config/secrets/admin/gpg.private')
  rescue StandardError
    nil
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'creates a admin user' do
    created_user = iam_user('administrator')
    output_user_arn = output(role: :full, name: 'admin_user_arn')

    expect(created_user).to(exist)
    expect(created_user.arn).to(eq(output_user_arn))
  end
  # rubocop:enable RSpec/MultipleExpectations

  it 'creates a admins group' do
    expect(iam_group('administrators')).to(exist)
  end

  it 'allows the admins group to do anything' do
    expect(iam_group('administrators'))
      .to(have_inline_policy('administrators-group-policy')
            .policy_document(<<~'DOC'))
              {
                "Version": "2012-10-17",
                "Statement": [
                  {
                    "Sid": "",
                    "Effect": "Allow",
                    "Action": "*",
                    "Resource": "*"
                  }
                ]
              }
    DOC
  end

  it 'adds the user to the admin group' do
    expect(iam_user('administrator'))
      .to(belong_to_iam_group('administrators'))
  end

  it 'creates a login profile for the user using the provided GPG key' do
    output_password = output(role: :full, name: 'admin_user_password')
    encrypted_password = StringIO.new(Base64.decode64(output_password))

    IOStreams::Pgp.import(key: private_gpg_key)
    password = IOStreams::Pgp::Reader
               .open(encrypted_password,
                     passphrase: gpg_key_passphrase) do |stdout|
      stdout.read.chomp
    end

    expect(password&.length).to(eq(48))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'creates an access key for the user using the provided GPG key' do
    output_access_key_id =
      output(role: :full, name: 'admin_user_access_key_id')
    output_secret_access_key =
      output(role: :full, name: 'admin_user_secret_access_key')
    encrypted_secret_access_key =
      StringIO.new(Base64.decode64(output_secret_access_key))

    IOStreams::Pgp.import(key: private_gpg_key)
    secret_access_key =
      IOStreams::Pgp::Reader
      .open(encrypted_secret_access_key,
            passphrase: gpg_key_passphrase) do |stdout|
        stdout.read.chomp
      end

    expect(output_access_key_id.length).to(be(20))
    expect(secret_access_key&.length).to(be(40))
  end
  # rubocop:enable RSpec/MultipleExpectations
end
