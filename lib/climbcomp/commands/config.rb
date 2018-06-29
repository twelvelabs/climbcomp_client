# frozen_string_literal: true

require_relative '../command'
require 'tty-table'

module Climbcomp
  module Commands
    class Config < Climbcomp::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        p = prompt(input: input, output: output)

        rows = []
        Climbcomp.config.each do |k, v|
          v = '[REDACTED]' if v.present? && k.to_s.end_with?('_token', '_secret')
          rows << [k, v.to_s]
        end

        table = TTY::Table.new(header: %w[Key Value], rows: rows)
        p.say table.render(:unicode, width: 80, resize: true)
      end
    end
  end
end
