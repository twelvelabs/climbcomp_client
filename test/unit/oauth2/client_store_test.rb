# frozen_string_literal: true

require 'test_helper'
require 'yaml'

class Oauth2ClientStoreTest < Climbcomp::Spec

  describe Climbcomp::Oauth2::ClientStore do

    let(:storage_path) { config_path('oauth2-client.yml') }

    it 'should have nil values by default' do
      client_store = Climbcomp::Oauth2::ClientStore.new(storage_path)
      assert_nil client_store.id
      assert_nil client_store.secret
      assert_equal false, client_store.present?
    end

    it 'should use stored values if present' do
      write_yaml(storage_path, client_id: '1234', client_secret: 'abcd')
      client_store = Climbcomp::Oauth2::ClientStore.new(storage_path)
      assert_equal '1234', client_store.id
      assert_equal 'abcd', client_store.secret
      assert_equal true, client_store.present?
    end

    it 'should register a new client' do
      response = JSON.generate(
        client_id: '8SXWY6j3afl2CP5ntwEOpMdPxxy49Gt2',
        client_secret: '5ntwEOpMdPxxy49Gt28SXWY6j3afl2CP'
      )
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: response, status: 201)
      client_store = Climbcomp::Oauth2::ClientStore.new(storage_path)
      assert_equal false, client_store.present?
      client_store.register
      assert_equal '8SXWY6j3afl2CP5ntwEOpMdPxxy49Gt2', client_store.id
      assert_equal '5ntwEOpMdPxxy49Gt28SXWY6j3afl2CP', client_store.secret
      assert_equal true, client_store.present?
    end

    it 'should raise if unexpected registration keys' do
      response = JSON.generate(
        not_client_id: 'foo',
        not_client_secret: 'bar'
      )
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: response, status: 201)
      client_store = Climbcomp::Oauth2::ClientStore.new(storage_path)
      assert_raises(StandardError) { client_store.register }
    end

    it 'should raise if registration fails' do
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: '', status: 400)
      client_store = Climbcomp::Oauth2::ClientStore.new(storage_path)
      assert_raises(StandardError) { client_store.register }
    end

  end

end
