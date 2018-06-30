# frozen_string_literal: true

require_relative '../command'

module Climbcomp
  module Commands
    class Logout < Climbcomp::Command

      # `token_store` arg used in unit tests
      def initialize(options = {}, token_store: nil)
        super(options)
        @token_store = token_store
      end

      def execute(input: $stdin, output: $stdout)
        p = prompt(input: input, output: output)

        if p.yes?('Are you sure?')
          Climbcomp.config.token = nil
          token_store.store(Climbcomp.config.token)
          p.ok 'Successfully logged out.'
        else
          p.ok 'Canceling.'
        end
      end

      def token_store
        @token_store ||= Climbcomp::OAuth2::TokenStore.new(Climbcomp.config.token_store_path)
      end

    end
  end
end
