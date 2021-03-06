# frozen_string_literal: true

require_relative '../command'

module Climbcomp
  module Commands
    class Login < Climbcomp::Command

      # Allowing the authorizer to be passed in for testing
      def initialize(options = {}, authorizer: nil)
        super(options)
        @authorizer = authorizer
      end

      def execute(input: $stdin, output: $stdout) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        p = prompt(input: input, output: output)
        if authorizer.authorized?
          p.warn 'Already logged in!'
          return
        end
        p.say "\n"
        p.say 'Attempting to open the authorization URL:'
        p.say "\n"
        p.say authorizer.authorize_url
        p.say "\n"
        p.say 'If the URL does not open automatically, paste it into your browser.'
        p.say 'Return here once you have authorized.'
        p.say 'Starting callback server...'
        p.say "\n"
        authorizer.authorize
        p.say "\n"
        if authorizer.authorized?
          p.ok 'Successfully authenticated.'
        else
          p.error 'Authentication failed!'
        end
      end

      def client_store
        @client_store ||= Climbcomp::OAuth2::ClientStore.new(Climbcomp.config.client_store_path)
      end

      def token_store
        @token_store ||= Climbcomp::OAuth2::TokenStore.new(Climbcomp.config.token_store_path)
      end

      def authorizer
        @authorizer ||= Climbcomp::OAuth2::Authorizer.new(
          client:       client_store.retrieve_or_register,
          token_store:  token_store
        )
      end

    end
  end
end
