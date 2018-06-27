# frozen_string_literal: true

require 'test_helper'
require 'climbcomp/commands/login'

class LoginTest < Climbcomp::Spec

  describe Climbcomp::Commands::Login do

    let(:input)   { StringIO.new }
    let(:output)  { StringIO.new }
    let(:options) { {} }
    # All the command does is delegate to (and provide CLI output for) the authorizer,
    # which is covered by it's own unit tests. Just stubbing it out here for convenience.
    let(:command) { Climbcomp::Commands::Login.new(options, authorizer: stub('authorizer')) }

    it 'should exit early if already logged in' do
      command.authorizer.expects(:authorized?).returns(true)
      command.authorizer.expects(:authorize).never

      command.execute(input: input, output: output)
      assert_equal true, output.string.include?('Already logged in')
    end

    it 'should authorize successfully' do
      command.authorizer.expects(:authorized?).twice.returns(false, true)
      command.authorizer.expects(:authorize_url).returns('https://authorize.me/')
      command.authorizer.expects(:authorize)

      command.execute(input: input, output: output)
      assert_equal true, output.string.include?('Successfully authenticated')
    end

    it 'should show error message on auth failure' do
      command.authorizer.expects(:authorized?).twice.returns(false, false)
      command.authorizer.expects(:authorize_url).returns('https://authorize.me/')
      command.authorizer.expects(:authorize)

      command.execute(input: input, output: output)
      assert_equal true, output.string.include?('Authentication failed')
    end

  end

end
