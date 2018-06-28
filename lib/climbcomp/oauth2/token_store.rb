# frozen_string_literal: true

require 'climbcomp/store'

module Climbcomp
  module OAuth2
    class TokenStore < Store

      ATTRIBUTES = %i[client_id client_secret access_token id_token refresh_token expires_at expires_in].freeze

      def retrieve(client = nil)
        attributes = presence(*ATTRIBUTES)
        return nil unless attributes.present?
        token = TokenFactory.create(attributes)
        return nil unless token.present? && token.client.present?
        if client
          # Validate that the client id/secret hasn't changed since we last stored the token.
          return nil unless token.client.id == client.id
        end
        token
      end

      def store(token)
        token ? insert(token_attributes(token)) : clear
      end

      private

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
