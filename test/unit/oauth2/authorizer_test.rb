# frozen_string_literal: true

require 'test_helper'

class OAuth2AuthorizerTest < Climbcomp::Spec

  describe Climbcomp::OAuth2::Authorizer do

    let(:token_values) do
      {
        client_id:      'client-id',
        client_secret:  'client-secret',
        access_token:   'access-token',
        id_token:       'id-token',
        refresh_token:  'refresh-token',
        expires_at:     '12345',
        expires_in:     '86400'
      }
    end
    let(:client)      { Climbcomp::OAuth2::ClientFactory.create(token_values.slice(:client_id, :client_secret)) }
    let(:token)       { Climbcomp::OAuth2::TokenFactory.create(token_values) }
    let(:token_store) { Climbcomp::OAuth2::TokenStore.new(config_path('oauth2-token.yml')) }
    let(:authorizer) do
      Climbcomp::OAuth2::Authorizer.new(client: client, token_store: token_store)
    end

    it 'should require a client and token store' do
      assert_raises(ArgumentError) { Climbcomp::OAuth2::Authorizer.new(client: nil, token_store: token_store) }
      assert_raises(ArgumentError) { Climbcomp::OAuth2::Authorizer.new(client: client, token_store: nil) }
    end

    it 'should return a token from the store' do
      token_store.expects(:retrieve).with(client).returns(token)
      assert_equal token, authorizer.token
    end

    it 'should delegate auth url to client' do
      client.auth_code.expects(:authorize_url).with(authorizer.authorize_params).returns('auth-url')
      assert_equal 'auth-url', authorizer.authorize_url
    end

    it 'should authorize' do
      authorizer.expects(:open_authorize_url)
      authorizer.callback_server = stub('server')
      authorizer.callback_server.expects(:start)
      authorizer.authorize
    end

    it 'should shutdown webrick on INT signal' do
      authorizer.expects(:open_authorize_url)
      authorizer.callback_server = stub('server')
      authorizer.callback_server.expects(:start).raises(Interrupt)
      authorizer.callback_server.expects(:shutdown)
      authorizer.authorize
    end

    it 'should handle the callback url' do
      client.auth_code.expects(:get_token).with('auth-code', redirect_uri: authorizer.callback_url).returns(token)
      authorizer.callback('auth-code')
      assert_equal 'access-token', authorizer.token.token
      assert_equal 'client-id', authorizer.token.client.id
    end

  end

end
