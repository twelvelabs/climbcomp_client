# frozen_string_literal: true

require 'test_helper'

class CommandTest < Climbcomp::Spec

  describe Climbcomp::Command do

    let(:command) { Climbcomp::Command.new }

    it 'should use the correct client_store path' do
      assert_equal config_path('oauth2-client.yml'), command.client_store.path
    end

    it 'should use the correct token_store path' do
      assert_equal config_path('oauth2-token.yml'), command.token_store.path
    end

    it 'should return a token if present' do
      login_user
      assert_equal 'client_id',     command.token.client.id
      assert_equal 'client_secret', command.token.client.secret
      assert_equal 'access_token',  command.token.token
      assert_equal 'refresh_token', command.token.refresh_token
    end

  end

end
