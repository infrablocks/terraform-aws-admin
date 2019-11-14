require 'spec_helper'
require 'iostreams'

describe 'user' do
  let(:user_name) { vars.admin_user_name }
  let(:user_arn) { output_for(:harness, 'admin_user_arn') }
  let(:group_name) { vars.admin_group_name }

  subject {
    iam_user(user_name)
  }

  it { should exist }
  its(:arn) { should eq(user_arn) }

  it { should belong_to_iam_group(group_name) }

  it 'outputs username and GPG encrypted login password' do
    username = output_for(:harness, 'admin_user_name')
    encrypted_password =
        StringIO.new(
            Base64.decode64(
                output_for(:harness, 'admin_user_password')))

    passphrase = configuration.gpg_key_passphrase
    private_key = File.read(configuration.private_gpg_key_path)

    IOStreams::Pgp.import(key: private_key)
    password = IOStreams::Pgp::Reader
        .open(encrypted_password, passphrase: passphrase) do |stdout|
      stdout.read.chomp
    end

    expect(username).to(eq(vars.admin_user_name))
    expect(password.length).to(be(32))
  end
end
