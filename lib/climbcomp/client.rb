# frozen_string_literal: true

module Climbcomp
  class Client

    attr_accessor :config

    def initialize(config: Climbcomp.config)
      @config = config
    end

    def connection
      Faraday.new(connection_options) do |c|
        c.request   :climbcomp_oauth2, config
        c.request   :json
        c.response  :json, content_type: /\bjson$/
        c.adapter   Faraday.default_adapter
      end
    end

    private

    def connection_options
      {
        url: config.oidc_audience,
        headers: {
          'Accept'          => 'application/json',
          'Accept-Charset'  => 'utf-8',
          'Content-Type'    => 'application/json',
          'User-Agent'      => config.user_agent
        }
      }
    end

  end
end
