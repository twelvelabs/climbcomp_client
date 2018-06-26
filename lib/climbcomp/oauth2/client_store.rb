# frozen_string_literal: true

require 'climbcomp/store'

module Climbcomp
  module OAuth2
    class ClientStore < Store

      AUTH_DOMAIN = 'https://climbcomp.auth0.com'

      def retrieve
        values = presence(:client_id, :client_secret)
        return nil unless values
        ::OAuth2::Client.new(values[:client_id], values[:client_secret], client_options)
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

      def client_options
        {
          site:           AUTH_DOMAIN,
          authorize_url:  '/authorize',
          token_url:      '/oauth/token'
        }
      end

      def send_registration_request
        client = {
          client_name:    'Climbcomp Ruby CLI',
          redirect_uris:  [Authorizer::CALLBACK_URL]
        }
        conn = ::Faraday.new(AUTH_DOMAIN)
        conn.post('/oidc/register', JSON.generate(client), content_type: 'application/json')
      end

    end
  end
end
