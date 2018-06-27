# frozen_string_literal: true

require_relative '../command'

module Climbcomp
  module Commands
    class Logout < Climbcomp::Command

      # `token_store` arg used in unit tests
      def initialize(options, token_store: nil)
        @options      = options
        @token_store  = token_store
      end

      def execute(input: $stdin, output: $stdout)
        p = prompt(input: input, output: output)

        if p.yes?('Are you sure?')
          token_store.store(nil)
          p.ok 'Successfully logged out.'
        else
          p.ok 'Canceling.'
        end
      end

      private

      def token_store_path
        @token_store_path ||= File.join(Dir.home, '.climbcomp', 'oauth2-token.yml')
      end

      def token_store
        @token_store ||= Climbcomp::OAuth2::TokenStore.new(token_store_path)
      end

    end
  end
end
