# frozen_string_literal: true

require 'thor'

module Climbcomp
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    DEFAULT_CREDENTIALS_PATH = File.join(Dir.home, '.climbcomp', 'credentials.yml')

    class_option :credentials_path, type: :string, default: DEFAULT_CREDENTIALS_PATH,
                                    desc: 'Path to credentials file (will be auto-created if missing).'

    desc 'version', 'climbcomp version'
    def version
      require_relative 'version'
      puts "v#{Climbcomp::VERSION}"
    end
    map %w[--version -v] => :version
  end
end
