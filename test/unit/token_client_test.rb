# frozen_string_literal: true

require 'test_helper'
require 'yaml'

class TokenClientTest < Climbcomp::Spec

  describe Climbcomp::TokenClient do

    let(:storage_path) { config_path('oauth2-client.yml') }

    it 'should have nil values by default' do
      token_client = Climbcomp::TokenClient.new(storage_path)
      assert_nil token_client.id
      assert_nil token_client.secret
      assert_equal false, token_client.present?
    end

    it 'should use stored values if present' do
      write_yaml(storage_path, client_id: '1234', client_secret: 'abcd')
      token_client = Climbcomp::TokenClient.new(storage_path)
      assert_equal '1234', token_client.id
      assert_equal 'abcd', token_client.secret
      assert_equal true, token_client.present?
    end

    it 'should register a new client' do
      response = JSON.generate(
        client_id: '8SXWY6j3afl2CP5ntwEOpMdPxxy49Gt2',
        client_secret: '5ntwEOpMdPxxy49Gt28SXWY6j3afl2CP'
      )
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: response, status: 201)
      token_client = Climbcomp::TokenClient.new(storage_path)
      assert_equal false, token_client.present?
      token_client.register
      assert_equal '8SXWY6j3afl2CP5ntwEOpMdPxxy49Gt2', token_client.id
      assert_equal '5ntwEOpMdPxxy49Gt28SXWY6j3afl2CP', token_client.secret
      assert_equal true, token_client.present?
    end

    it 'should raise if unexpected registration keys' do
      response = JSON.generate(
        not_client_id: 'foo',
        not_client_secret: 'bar'
      )
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: response, status: 201)
      token_client = Climbcomp::TokenClient.new(storage_path)
      assert_raises(StandardError) { token_client.register }
    end

    it 'should raise if registration fails' do
      stub_request(:post, 'https://climbcomp.auth0.com/oidc/register').to_return(body: '', status: 400)
      token_client = Climbcomp::TokenClient.new(storage_path)
      assert_raises(StandardError) { token_client.register }
    end

  end

end
