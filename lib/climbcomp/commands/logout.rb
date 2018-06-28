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
          token_store.store(nil)
          p.ok 'Successfully logged out.'
        else
          p.ok 'Canceling.'
        end
      end

    end
  end
end
