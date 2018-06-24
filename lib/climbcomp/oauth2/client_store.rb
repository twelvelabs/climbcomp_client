# frozen_string_literal: true

require 'climbcomp/store'
require 'faraday'

module Climbcomp
  module Oauth2
    class ClientStore < Store

      def id
        transaction(true) { |s| s[:client_id] }
      end

      def secret
        transaction(true) { |s| s[:client_secret] }
      end

      def present?
        transaction(true) { |s| s[:client_id].present? && s[:client_secret].present? }
      end

      def register
        response = send_registration_request
        raise 'Unable to register client' unless response.success?
        client = JSON.parse(response.body)
        raise 'Malformed registration response' unless client['client_id'].present? && client['client_secret'].present?
        insert(client)
      end

      private

      def send_registration_request
        client = {
          client_name: 'Climbcomp Ruby CLI',
          redirect_uris: [Authorizer::CALLBACK_URL]
        }
        conn = Faraday.new('https://climbcomp.auth0.com')
        conn.post('/oidc/register', JSON.generate(client), content_type: 'application/json')
      end

    end
  end
end
