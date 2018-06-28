# frozen_string_literal: true

module Climbcomp
  module OAuth2
    class TokenFactory

      ATTRIBUTES = %i[client_id client_secret access_token id_token refresh_token expires_at expires_in].freeze

      class << self
        def create(params)
          ::OAuth2::AccessToken.from_hash(extract_client(params), params)
        end

        def attributes_for(token)
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

        private

        def extract_client(params)
          params = params.extract!(:client_id, :client_secret)
          return nil unless params.present?
          ClientFactory.create(params)
        end
      end

    end
  end
end
