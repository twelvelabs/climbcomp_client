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

    desc 'version', 'climbcomp version'
    def version
      require_relative 'version'
      puts "v#{Climbcomp::VERSION}"
    end
    map %w[--version -v] => :version

    desc 'config', 'Show current config'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def config(*)
      if options[:help]
        invoke :help, ['config']
      else
        require_relative 'commands/config'
        Climbcomp::Commands::Config.new(options).execute
      end
    end

    desc 'logout', 'Clear the auth token'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def logout(*)
      if options[:help]
        invoke :help, ['logout']
      else
        require_relative 'commands/logout'
        Climbcomp::Commands::Logout.new(options).execute
      end
    end

    desc 'login', 'Generate an auth token'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def login(*)
      if options[:help]
        invoke :help, ['login']
      else
        require_relative 'commands/login'
        Climbcomp::Commands::Login.new(options).execute
      end
    end
  end
end
