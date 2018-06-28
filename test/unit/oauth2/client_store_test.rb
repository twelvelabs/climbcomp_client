# frozen_string_literal: true

require 'test_helper'

class OAuth2ClientStoreTest < Climbcomp::Spec

  describe Climbcomp::OAuth2::ClientStore do

    let(:client_store_path) { config_path('oauth2-client.yml') }
    let(:client_store)      { Climbcomp::OAuth2::ClientStore.new(client_store_path) }

    it 'should retrieve nil client by default' do
      assert_nil client_store.retrieve
    end

    it 'should retrieve from stored values if present' do
      write_yaml(client_store_path, client_id: '1234', client_secret: 'abcd')
      client = client_store.retrieve
      assert_equal '1234', client.id
      assert_equal 'abcd', client.secret
    end

    it 'should register a new client' do
      # sanity check
      assert_nil client_store.retrieve
      # stub the registration API response
      response = JSON.generate(
        client_id: '8SXWY6j3afl2CP5ntwEOpMdPxxy49Gt2',
        client_secret: '5ntwEOpMdPxxy49Gt28SXWY6j3afl2CP'
      )
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: response, status: 201)
      # register a new client
      client = client_store.register
      assert_equal '8SXWY6j3afl2CP5ntwEOpMdPxxy49Gt2', client.id
      assert_equal '5ntwEOpMdPxxy49Gt28SXWY6j3afl2CP', client.secret
      # future `retrieve` requests returns the same client
      client = client_store.retrieve
      assert_equal '8SXWY6j3afl2CP5ntwEOpMdPxxy49Gt2', client.id
      assert_equal '5ntwEOpMdPxxy49Gt28SXWY6j3afl2CP', client.secret
    end

    it 'should raise if unexpected registration keys' do
      response = JSON.generate(
        not_client_id: 'foo',
        not_client_secret: 'bar'
      )
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: response, status: 201)
      assert_raises(StandardError) { client_store.register }
    end

    it 'should raise if registration fails' do
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: '', status: 400)
      assert_raises(StandardError) { client_store.register }
    end

  end

end
