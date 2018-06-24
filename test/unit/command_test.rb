# frozen_string_literal: true

require 'test_helper'

class CommandTest < Climbcomp::Spec

  describe Climbcomp::Command do

    it 'should create a credentials store' do
      command = Climbcomp::Command.new(credentials_path: config_path('credentials.yml'))
      assert_instance_of Climbcomp::Store, command.credentials_store
      assert_equal config_path('credentials.yml'), command.credentials_store.path
    end

    it 'should return credentials if all present' do
      command = Climbcomp::Command.new(credentials_path: config_path('credentials.yml'))
      command.credentials_store.transaction do |s|
        s[:client_id]     = 'value'
        s[:client_secret] = 'value'
        s[:access_token]  = 'value'
        s[:refresh_token] = 'value'
        s[:expires_at]    = 'value'
      end
      refute_nil command.credentials
      assert_equal 5, command.credentials.size
    end

    it 'should have nil credentials if any are missing' do
      command = Climbcomp::Command.new(credentials_path: config_path('credentials.yml'))
      command.credentials_store.transaction do |s|
        s[:client_id]     = 'value'
        s[:client_secret] = 'value'
        s[:access_token]  = ''
        s[:refresh_token] = ''
        s[:expires_at]    = ''
      end
      assert_nil command.credentials
    end

  end

end
