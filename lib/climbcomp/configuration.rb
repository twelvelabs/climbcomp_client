# frozen_string_literal: true

module Climbcomp
  class Configuration

    # All keys defined here will have accessors defined and defaults set
    DEFAULT_OPTIONS = {
      oidc_client_id:               nil,
      oidc_client_secret:           nil,
      oidc_access_token:            nil,
      oidc_refresh_token:           nil,
      oidc_expires_at:              nil,
      oidc_expires_in:              nil,
      oidc_audience:                'https://staging.climbcomp.com/',
      oidc_issuer:                  'https://climbcomp.auth0.com/',
      oidc_scopes:                  'openid profile email offline_access',
      oidc_authorization_endpoint:  '/authorize',
      oidc_token_endpoint:          '/oauth/token',
      oidc_revocation_endpoint:     '/oauth/revoke',
      oidc_userinfo_endpoint:       '/userinfo',
      oidc_registration_endpoint:   '/oidc/register',
      oidc_redirect_uri:            'http://localhost:3001/oauth/callback',
      user_agent:                   "Climbcomp Ruby Gem #{Climbcomp::VERSION}"
    }.freeze

    attr_accessor(*DEFAULT_OPTIONS.keys)

    def initialize(options = {})
      options = DEFAULT_OPTIONS.merge(options.with_indifferent_access)
      options.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

  end
end
