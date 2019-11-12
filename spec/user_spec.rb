require 'spec_helper'

describe 'user' do
  let(:user_name) { vars.admin_user_name }
  let(:user_arn) {
    output_for(:harness, 'admin_user_arn')
  }
  let(:group_name) { vars.admin_group_name }

  subject {
    iam_user(user_name)
  }

  it { should exist }
  its(:arn) { should eq(user_arn) }

  it { should belong_to_iam_group(group_name) }
end
