# frozen_string_literal: true

module Climbcomp
  module OAuth2
    class TokenFactory

      class << self
        def create(params)
          ::OAuth2::AccessToken.from_hash(extract_client(params), params)
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
