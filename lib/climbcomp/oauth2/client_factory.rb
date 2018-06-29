# frozen_string_literal: true

module Climbcomp
  module OAuth2
    class ClientFactory

      class << self
        def create(params)
          raise ArgumentError, 'Missing client_id or client_secret' unless valid_params?(params)
          ::OAuth2::Client.new(
            params[:client_id],
            params[:client_secret],
            site:           Climbcomp.config.oidc_issuer,
            authorize_url:  Climbcomp.config.oidc_authorization_endpoint,
            token_url:      Climbcomp.config.oidc_token_endpoint
          )
        end

        private

        def valid_params?(params)
          params[:client_id].present? && params[:client_secret].present?
        end
      end

    end
  end
end
