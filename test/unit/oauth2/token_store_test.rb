# frozen_string_literal: true

require 'test_helper'

class OAuth2TokenStoreTest < Climbcomp::Spec

  describe Climbcomp::OAuth2::TokenStore do

    let(:client)      { stub(id: 'test_client_id', secret: 'test_client_secret') }
    let(:token_store) { Climbcomp::OAuth2::TokenStore.new(Climbcomp.config.token_store_path) }
    let(:token_values) do
      {
        client_id:      'test_client_id',
        client_secret:  'test_client_secret',
        access_token:   'test_access_token',
        id_token:       'test_id_token',
        refresh_token:  'test_refresh_token',
        expires_at:     '12345',
        expires_in:     '86400'
      }
    end

    it 'should retrieve nil by default' do
      token = token_store.retrieve
      assert_nil token
    end

    it 'should retrieve token if present' do
      write_yaml(Climbcomp.config.token_store_path, token_values)
      token = token_store.retrieve
      assert_equal 'test_client_id', token.client.id
      assert_equal 'test_access_token', token.token
      assert_equal 'test_id_token', token[:id_token]
      assert_equal 'test_refresh_token', token.refresh_token
      assert_equal 12_345, token.expires_at
      assert_equal 86_400, token.expires_in
    end

    it 'should validate client when retrieving' do
      write_yaml(Climbcomp.config.token_store_path, token_values)
      # When retrieving w/ an oauth client, we validate that the client's id/secret
      # match what's in the store
      token = token_store.retrieve(client)
      assert_equal 'test_client_id', token.client.id
      # We return a nil token if there's a client mismatch
      token = token_store.retrieve(stub(id: 'lol', secret: 'wat'))
      assert_nil token
    end

    it 'should store a token' do
      token = Climbcomp::OAuth2::TokenFactory.create(token_values)
      token_store.store(token)
      stored = token_store.retrieve(client)
      assert_equal 'test_access_token', stored.token
      assert_equal 'test_client_id', stored.client.id
    end

  end

end
