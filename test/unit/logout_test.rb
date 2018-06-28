# frozen_string_literal: true

require 'test_helper'
require 'climbcomp/commands/logout'

class LogoutTest < Climbcomp::Spec

  describe Climbcomp::Commands::Logout do

    let(:input)   { StringIO.new }
    let(:output)  { StringIO.new }
    let(:command) { Climbcomp::Commands::Logout.new }

    it 'should logout if the user confirms' do
      login_user

      input << 'Yes'
      input.rewind

      command.execute(input: input, output: output)
      assert_equal true, output.string.include?('Successfully logged out')
      assert_nil command.token_store.retrieve
    end

    it 'should not logout if the user cancels' do
      login_user

      input << 'No'
      input.rewind

      command.execute(input: input, output: output)
      assert_equal true, output.string.include?('Canceling')
      refute_nil command.token_store.retrieve
    end

  end

end
