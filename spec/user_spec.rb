require 'spec_helper'

describe 'user' do
  let(:user_name) { vars.admin_user_name }
  let(:user_arn) {
    output_for(:harness, 'admin_user_arn')
  }

  subject {
    iam_user(user_name)
  }

  it { should exist }
  its(:arn) { should eq(user_arn) }
end
