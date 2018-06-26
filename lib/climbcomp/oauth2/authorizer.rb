# frozen_string_literal: true

silence_warnings do
  require 'launchy'
end
require 'securerandom'
require 'uri'
require 'webrick'

module Climbcomp
  module OAuth2
    class Authorizer
      CALLBACK_URL = 'http://localhost:3001/oauth2/callback'

      attr_accessor :client, :token_store, :state
      attr_writer :callback_server

      def initialize(client:, token_store:)
        raise ArgumentError, 'client required'      unless client
        raise ArgumentError, 'token_store required' unless token_store
        @client = client
        @token_store = token_store
        @state = SecureRandom.hex
      end

      def authorized?
        token.present?
      end

      def token
        token_store.retrieve(client)
      end

      # TODO: make audience and custom scopes configurable.
      def authorize_params
        {
          audience:     'https://staging.climbcomp.com/',
          redirect_uri: callback_url,
          scope:        'openid profile email offline_access admin',
          state:        state
        }
      end

      def authorize_url
        client.auth_code.authorize_url(authorize_params)
      end

      def authorize
        # Open the auth url in a web browser. Once the user authorizes, they will be redirected
        # to the callback url (which will be handled via the webrick server we're about to start)
        open_authorize_url
        # Start up the callback server.
        callback_server.start
        # Execution will block *here* until the callback url is requested, which executes `#callback_server_proc`.
        # After the proc runs `#callback`, it shuts down the server; unblocking execution and returning the stored token.
        token
      rescue Interrupt
        callback_server.shutdown
      end

      def callback_url
        CALLBACK_URL
      end

      def callback(code)
        return unless code.present?
        token = client.auth_code.get_token(code, redirect_uri: callback_url)
        token_store.store(token)
      end

      def callback_server
        @callback_server ||= begin
          s = WEBrick::HTTPServer.new('Port': 3001)
          s.mount_proc(URI(callback_url).path, callback_server_proc)
          s
        end
      end

      private

      def open_authorize_url
        ::Launchy.open(authorize_url) do |error|
          puts "Attempted to open authorization URL failed: #{error}"
          puts "\n"
        end
      end

      # Runs whenever the auth provider redirects back to the callback url
      # Simply closes the browser window, runs the callback, and shuts down the server.
      def callback_server_proc
        authorizer = self # closure reference so the proc can trigger the callback
        proc do |req, resp|
          resp.body = '<html><head><script>open(location, "_self").close();</script></head><body>Close this window</body></html>'
          resp.content_type = 'text/html'
          resp.status = 200
          authorizer.callback(req.query['code']) if req.query['state'] == authorizer.state
          authorizer.callback_server.shutdown
        end
      end

    end
  end
end
