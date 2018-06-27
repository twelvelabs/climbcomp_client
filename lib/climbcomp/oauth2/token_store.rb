# frozen_string_literal: true

require 'climbcomp/store'

module Climbcomp
  module OAuth2
    class TokenStore < Store

      CLIENT_ATTRIBUTES = %i[client_id client_secret].freeze
      TOKEN_ATTRIBUTES  = %i[access_token refresh_token expires_at expires_in].freeze
      ALL_ATTRIBUTES    = (CLIENT_ATTRIBUTES + TOKEN_ATTRIBUTES).freeze

      def retrieve(client = nil)
        values = presence(*ALL_ATTRIBUTES)
        return nil if values.blank?
        return nil if client && !valid_client?(client)
        ::OAuth2::AccessToken.from_hash(client, values.slice(*TOKEN_ATTRIBUTES))
      end

      def store(token)
        token ? insert(token_attributes(token)) : clear
      end

      private

      def valid_client?(client)
        values = presence(*CLIENT_ATTRIBUTES)
        client.id == values[:client_id] && client.secret == values[:client_secret]
      end

      def token_attributes(token)
        {
          client_id:      token.client.id,
          client_secret:  token.client.secret,
          access_token:   token.token,
          refresh_token:  token.refresh_token,
          expires_at:     token.expires_at,
          expires_in:     token.expires_in
        }
      end

    end
  end
end
