# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/kernel/reporting'
require 'active_support/core_ext/object/blank'
require 'oauth2' # must be required before faraday
require 'faraday'
require 'yaml'
require 'yaml/store'

require 'climbcomp/version'
require 'climbcomp/configuration'
require 'climbcomp/oauth2/authorizer'
require 'climbcomp/oauth2/client_store'
require 'climbcomp/oauth2/token_store'
require 'climbcomp/store'

module Climbcomp

  class << self
    attr_writer :config

    # Global configuration
    def config
      @config ||= Configuration.new
    end

    # Block syntax for modifying global configuration
    # Example:
    #
    #   Climbcomp.configure do |c|
    #     c.oidc_client_id      = ENV['CLIMBCOMP_CLIENT_ID']
    #     c.oidc_client_secret  = ENV['CLIMBCOMP_CLIENT_SECRET']
    #   end
    #
    def configure
      yield(config)
    end

    # Reset global state. Useful in tests.
    def reset!
      @config = nil
    end
  end

end
