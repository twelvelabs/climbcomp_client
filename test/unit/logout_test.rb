# frozen_string_literal: true

require 'test_helper'
require 'climbcomp/commands/logout'

class LogoutTest < Climbcomp::Spec

  describe Climbcomp::Commands::Logout do

    let(:input)   { StringIO.new }
    let(:output)  { StringIO.new }
    let(:options) { {} }
    let(:command) { Climbcomp::Commands::Logout.new(options, token_store: token_store) }

    let(:token_store)       { Climbcomp::OAuth2::TokenStore.new(token_store_path) }
    let(:token_store_path)  { config_path('oauth2-token.yml') }

    before do
      token_store.insert(
        client_id:      'client_id',
        client_secret:  'client_secret',
        access_token:   'access_token',
        id_token:       'id_token',
        refresh_token:  'refresh_token',
        expires_at:     'expires_at',
        expires_in:     'expires_in'
      )
    end

    it 'should logout if the user confirms' do
      input << 'Yes'
      input.rewind

      command.execute(input: input, output: output)
      assert_equal true, output.string.include?('Successfully logged out')
      assert_nil token_store.retrieve
    end

    it 'should not logout if the user cancels' do
      input << 'No'
      input.rewind

      command.execute(input: input, output: output)
      assert_equal true, output.string.include?('Canceling')
      refute_nil token_store.retrieve
    end

  end

end
