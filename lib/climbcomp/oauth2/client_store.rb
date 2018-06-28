# frozen_string_literal: true

require 'climbcomp/store'

module Climbcomp
  module OAuth2
    class ClientStore < Store

      def retrieve
        values = presence(:client_id, :client_secret)
        return nil unless values
        ClientFactory.create(values)
      end

      def register
        response = send_registration_request
        raise 'Unable to register client' unless response.success?
        client = JSON.parse(response.body)
        raise 'Malformed registration response' unless client['client_id'].present? && client['client_secret'].present?
        insert(client)
        retrieve
      end

      private

      def send_registration_request
        client = {
          client_name:    Climbcomp.config.user_agent,
          redirect_uris:  [Climbcomp.config.oidc_redirect_uri]
        }
        conn = ::Faraday.new(url: Climbcomp.config.oidc_issuer)
        conn.post(Climbcomp.config.oidc_registration_endpoint, JSON.generate(client), content_type: 'application/json')
      end

    end
  end
end
