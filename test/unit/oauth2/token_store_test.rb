# frozen_string_literal: true

require 'test_helper'

class OAuth2TokenStoreTest < Climbcomp::Spec

  describe Climbcomp::OAuth2::TokenStore do

    let(:storage_path) { config_path('oauth2-token.yml') }
    let(:storage_values) do
      {
        client_id:      'test_client_id',
        client_secret:  'test_client_secret',
        access_token:   'test_access_token',
        refresh_token:  'test_refresh_token',
        expires_at:     '12345',
        expires_in:     '86400'
      }
    end

    it 'should retrieve nil by default' do
      token_store = Climbcomp::OAuth2::TokenStore.new(storage_path)
      token = token_store.retrieve
      assert_nil token
    end

    it 'should retrieve token if present' do
      write_yaml(storage_path, storage_values)
      token_store = Climbcomp::OAuth2::TokenStore.new(storage_path)
      token = token_store.retrieve
      assert_instance_of ::OAuth2::AccessToken, token
      assert_nil token.client
      assert_equal 'test_access_token', token.token
      assert_equal 'test_refresh_token', token.refresh_token
      assert_equal 12_345, token.expires_at
      assert_equal 86_400, token.expires_in
    end

    it 'should validate client when retrieving' do
      write_yaml(storage_path, storage_values)
      token_store = Climbcomp::OAuth2::TokenStore.new(storage_path)
      # When retrieving w/ an oauth client, we validate that the client's id/secret
      # match what's in the store
      correct_client = stub(id: 'test_client_id', secret: 'test_client_secret')
      token = token_store.retrieve(correct_client)
      assert_equal correct_client, token.client
      # We return a nil token if there's a client mismatch
      incorrect_client = stub(id: 'lol', secret: 'wat')
      token = token_store.retrieve(incorrect_client)
      assert_nil token
    end

    it 'should store a token' do
      client = stub(id: 'test_client_id', secret: 'test_client_secret')
      token_values = storage_values.slice(:access_token, :refresh_token, :expires_at, :expires_in)
      token = ::OAuth2::AccessToken.from_hash(client, token_values)

      token_store = Climbcomp::OAuth2::TokenStore.new(storage_path)
      token_store.store(token)
      stored = token_store.retrieve(client)

      assert_equal 'test_access_token', stored.token
      assert_equal client, stored.client
    end

  end

end
