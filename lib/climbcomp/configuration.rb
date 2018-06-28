# frozen_string_literal: true

module Climbcomp
  class Configuration

    # All keys defined here will have accessors defined and defaults set
    DEFAULT_OPTIONS = {
      oidc_client_id:               nil,
      oidc_client_secret:           nil,
      oidc_access_token:            nil,
      oidc_id_token:                nil,
      oidc_refresh_token:           nil,
      oidc_expires_at:              nil,
      oidc_audience:                'https://staging.climbcomp.com/',
      oidc_issuer:                  'https://climbcomp.auth0.com/',
      oidc_scopes:                  'openid profile email offline_access',
      oidc_authorization_endpoint:  '/authorize',
      oidc_token_endpoint:          '/oauth/token',
      oidc_revocation_endpoint:     '/oauth/revoke',
      oidc_userinfo_endpoint:       '/userinfo',
      oidc_registration_endpoint:   '/oidc/register',
      oidc_redirect_uri:            'http://localhost:3001/oauth/callback',

      client_store_path:            File.join(Dir.home, '.climbcomp', 'oauth2-client.yml'),
      token_store_path:             File.join(Dir.home, '.climbcomp', 'oauth2-token.yml'),

      user_agent:                   "Climbcomp Ruby Gem #{Climbcomp::VERSION}"
    }.freeze

    attr_accessor(*DEFAULT_OPTIONS.keys)

    class << self
      def from_token(token)
        config = new
        attributes = Climbcomp::OAuth2::TokenFactory.attributes_for(token)
        # TODO: remove `oidc_` prefixes, so we can just call `new(attributes)`
        attributes.each do |k, v|
          writer = "oidc_#{k}=".to_sym
          config.send(writer, v) if config.respond_to?(writer)
        end
        config
      end
    end

    def initialize(options = {})
      options = DEFAULT_OPTIONS.merge(options.with_indifferent_access)
      options.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    def to_token
      # TODO: remove `oidc_` and implement `#[]` so we can just call `create(self)`
      Climbcomp::OAuth2::TokenFactory.create(
        client_id:     oidc_client_id,
        client_secret: oidc_client_secret,
        access_token:  oidc_access_token,
        id_token:      oidc_id_token,
        refresh_token: oidc_refresh_token,
        expires_at:    oidc_expires_at
      )
    end

  end
end
