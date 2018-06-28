# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < Climbcomp::Spec

  describe Climbcomp::Configuration do

    it 'has default values' do
      config = Climbcomp::Configuration.new
      # auth credentials should be nil
      assert_nil config.oidc_client_id
      assert_nil config.oidc_client_secret
      assert_nil config.oidc_access_token
      assert_nil config.oidc_id_token
      assert_nil config.oidc_refresh_token
      assert_nil config.oidc_expires_at
      # auth urls should have valid defaults
      assert_equal 'https://climbcomp.com/',                config.oidc_audience
      assert_equal 'https://climbcomp.auth0.com/',          config.oidc_issuer
      assert_equal 'openid profile email offline_access',   config.oidc_scopes
      assert_equal '/authorize',                            config.oidc_authorization_endpoint
      assert_equal '/oauth/token',                          config.oidc_token_endpoint
      assert_equal '/oauth/revoke',                         config.oidc_revocation_endpoint
      assert_equal '/userinfo',                             config.oidc_userinfo_endpoint
      assert_equal '/oidc/register',                        config.oidc_registration_endpoint
      assert_equal 'http://localhost:3001/oauth/callback',  config.oidc_redirect_uri
    end

    it 'should allow overriding defaults' do
      config = Climbcomp::Configuration.new(
        oidc_client_id:     'client-id',
        oidc_client_secret: 'client-secret',
        oidc_issuer:        'https://auth.climbcomp.com/'
      )
      assert_equal 'client-id',                   config.oidc_client_id
      assert_equal 'client-secret',               config.oidc_client_secret
      assert_equal 'https://auth.climbcomp.com/', config.oidc_issuer
    end

    it 'should set token options from oauth token' do
      attributes = {
        client_id:      'test_client_id',
        client_secret:  'test_client_secret',
        access_token:   'test_access_token',
        id_token:       'test_id_token',
        refresh_token:  'test_refresh_token',
        expires_at:     '12345'
      }
      config = Climbcomp::Configuration.new
      config.token = Climbcomp::OAuth2::TokenFactory.create(attributes)
      assert_equal 'test_client_id',      config.oidc_client_id
      assert_equal 'test_client_secret',  config.oidc_client_secret
      assert_equal 'test_access_token',   config.oidc_access_token
      assert_equal 'test_id_token',       config.oidc_id_token
      assert_equal 'test_refresh_token',  config.oidc_refresh_token
      assert_equal 12_345,                config.oidc_expires_at
    end

    it 'should handle setting token to nil' do
      config = Climbcomp::Configuration.new(
        oidc_client_id:     'client-id',
        oidc_client_secret: 'client-secret'
      )
      config.token = nil
      assert_equal 'client-id',     config.oidc_client_id
      assert_equal 'client-secret', config.oidc_client_secret
    end

    it 'should generate an oauth token' do
      config = Climbcomp::Configuration.new(
        oidc_client_id:      'test_client_id',
        oidc_client_secret:  'test_client_secret',
        oidc_access_token:   'test_access_token',
        oidc_id_token:       'test_id_token',
        oidc_refresh_token:  'test_refresh_token',
        oidc_expires_at:     '12345'
      )
      token = config.token
      assert_equal 'test_client_id',      token.client.id
      assert_equal 'test_client_secret',  token.client.secret
      assert_equal 'test_access_token',   token.token
      assert_equal 'test_id_token',       token[:id_token]
      assert_equal 'test_refresh_token',  token.refresh_token
      assert_equal 12_345,                token.expires_at
    end

  end

end
