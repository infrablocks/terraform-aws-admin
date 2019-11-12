require 'spec_helper'

describe 'group' do
  let(:group_name) { vars.admin_group_name }
  let(:group_arn) {
    output_for(:harness, 'admin_group_arn')
  }
  let(:group_policy_name) {
    output_for(:harness, 'admin_group_policy_name')
  }

  subject {
    iam_group(group_name)
  }

  it { should exist }
  its(:arn) { should eq(group_arn) }
  it {
    should have_inline_policy(group_policy_name).policy_document(<<-'DOC')
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
  }
end
