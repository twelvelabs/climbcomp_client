# frozen_string_literal: true

require 'climbcomp/store'

module Climbcomp
  module OAuth2
    class TokenStore < Store

      def retrieve(client = nil)
        attributes = presence(*TokenFactory::ATTRIBUTES)
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
        token ? insert(TokenFactory.attributes_for(token)) : clear
      end

    end
  end
end
