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
      assert_equal 'https://staging.climbcomp.com/',        config.oidc_audience
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

  end

end
