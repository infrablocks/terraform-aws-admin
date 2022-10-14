# frozen_string_literal: true

require 'spec_helper'

describe 'group' do
  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a group with name "admins"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_group')
              .with_attribute_value(:name, 'admins'))
    end

    it 'creates a group policy allowing full AWS access' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_group_policy')
              .with_attribute_value(:name, 'admins-group-policy')
              .with_attribute_value(:group, 'admins')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: '*',
                  Resource: '*'
                )
              ))
    end

    it 'outputs the group ARN' do
      expect(@plan)
        .to(include_output_creation(name: 'admin_group_arn'))
    end

    it 'outputs the group policy name' do
      expect(@plan)
        .to(include_output_creation(name: 'admin_group_policy_name'))
    end
  end

  describe 'when admin group name provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.admin_group_name = 'administrators'
      end
    end

    it 'creates a group with the specified name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_group')
              .with_attribute_value(:name, 'administrators'))
    end

    it 'creates a group policy allowing full AWS access' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_group_policy')
              .with_attribute_value(:name, 'administrators-group-policy')
              .with_attribute_value(:group, 'administrators')
              .with_attribute_value(
                :policy,
                a_policy_with_statement(
                  Effect: 'Allow',
                  Action: '*',
                  Resource: '*'
                )
              ))
    end
  end

  describe 'when admin group policy contents provided' do
    before(:context) do
      @policy_contents = <<~'DOC'
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "CustomAdminStatement",
              "Effect": "Allow",
              "Action": "*",
              "Resource": "*"
            },
            {
              "Sid": "CustomAdminStatement",
              "Effect": "Deny",
              "Action": "route53:*",
              "Resource": "*"
            }
          ]
        }
      DOC
      @plan = plan(role: :root) do |vars|
        vars.admin_group_policy_contents = @policy_contents
      end
    end

    it 'creates a group policy using the provided policy contents' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_iam_group_policy')
              .with_attribute_value(:name, 'admins-group-policy')
              .with_attribute_value(:group, 'admins')
              .with_attribute_value(:policy, @policy_contents))
    end
  end
end
