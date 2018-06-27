# frozen_string_literal: true

require 'climbcomp/store'

module Climbcomp
  module OAuth2
    class TokenStore < Store

      CLIENT_ATTRIBUTES = %i[client_id client_secret].freeze
      TOKEN_ATTRIBUTES  = %i[access_token id_token refresh_token expires_at expires_in].freeze

      def retrieve(expected_client = nil)
        found = token
        return nil if found.blank? || found.client.blank?
        return nil if expected_client && client_mismatch?(expected_client)
        found
      end

      def store(token)
        token ? insert(token_attributes(token)) : clear
      end

      private

      # Validate that the client id/secret hasn't changed since we last stored the token.
      def client_mismatch?(expected)
        client.blank? || client.id != expected.id || client.secret != expected.secret
      end

      def client
        attributes = presence(*CLIENT_ATTRIBUTES)
        return nil unless attributes.present?
        ::OAuth2::Client.new(
          attributes[:client_id],
          attributes[:client_secret],
          site:           Climbcomp.config.oidc_issuer,
          authorize_url:  Climbcomp.config.oidc_authorization_endpoint,
          token_url:      Climbcomp.config.oidc_token_endpoint
        )
      end

      def token
        attributes = presence(*TOKEN_ATTRIBUTES)
        return nil unless attributes.present?
        ::OAuth2::AccessToken.from_hash(client, attributes)
      end

      def token_attributes(token)
        {
          client_id:      token.client.id,
          client_secret:  token.client.secret,
          access_token:   token.token,
          id_token:       token['id_token'] || token[:id_token],
          refresh_token:  token.refresh_token,
          expires_at:     token.expires_at,
          expires_in:     token.expires_in
        }
      end

    end
  end
end
