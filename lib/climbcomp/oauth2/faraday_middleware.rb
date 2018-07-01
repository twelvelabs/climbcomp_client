# frozen_string_literal: true

module Climbcomp
  module OAuth2
    class FaradayMiddleware < Faraday::Middleware

      extend Forwardable
      attr_reader :config

      def initialize(app, config = nil)
        super(app)
        @config = config
      end

      def call(env)
        if config.token
          config.token = config.token.refresh! if config.token.expired?
          env[:request_headers]['Authorization'] = "Bearer #{config.token.token}"
        end
        @app.call(env)
      end

    end
  end
end

::Faraday::Request.register_middleware climbcomp_oauth2: Climbcomp::OAuth2::FaradayMiddleware
