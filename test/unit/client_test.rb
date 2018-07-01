# frozen_string_literal: true

require 'test_helper'

class CommandTest < Climbcomp::Spec

  describe Climbcomp::Client do

    let(:token) do
      t = Climbcomp::OAuth2::TokenFactory.create(
        client_id:      'client-id',
        client_secret:  'client-secret',
        access_token:   'access-token',
        id_token:       'id-token',
        refresh_token:  'refresh-token',
        expires_at:     '12345'
      )
      # refresh logic is tested elsewhere
      t.stubs(:expired?).returns(false)
      t
    end

    it 'should use the default config if none passed' do
      assert_equal Climbcomp.config, Climbcomp::Client.new.config
    end

    it 'should accept a custom config' do
      client = create_client(oidc_client_id: 'custom')
      assert_equal 'custom', client.config.oidc_client_id
    end

    it 'does not include an auth header if token missing' do
      stub_api_request(:post, '/athletes', unauthenticated: true)
        .to_return(
          api_response(status: 401)
        )
      response = create_client(token: nil).connection.post('/athletes')
      assert_equal 401, response.status
    end

    it 'parses API request bodies as JSON' do
      athlete = { name: 'Adam Ondra' }
      stub_api_request(:post, '/athletes', data: athlete)
        .to_return(
          api_response(status: 201, data: { id: 1, name: 'Adam Ondra' })
        )
      response = create_client.connection.post('/athletes', athlete)
      assert_equal 201,           response.status
      assert_equal 1,             response.body['id']
      assert_equal 'Adam Ondra',  response.body['name']
    end

    it 'parses API response bodies as JSON' do
      stub_api_request(:get, '/athletes/1')
        .to_return(
          api_response(status: 200, data: { id: 1, name: 'Adam Ondra' })
        )
      response = create_client.connection.get('/athletes/1')
      assert_equal 200,           response.status
      assert_equal 1,             response.body['id']
      assert_equal 'Adam Ondra',  response.body['name']
    end

    private

    def create_client(options = {})
      options = {
        oidc_audience:  'https://example.com/',
        user_agent:     'Climbcomp',
        token:          token
      }.merge(options)
      Climbcomp::Client.new(config: Climbcomp::Configuration.new(options))
    end

    def stub_api_request(method, path, data: nil, headers: {}, unauthenticated: false)
      path    = path.gsub(%r{^\/}, '')
      headers = api_request_headers(headers, unauthenticated)
      body    = data ? data.to_json : nil
      stub_request(method, "https://example.com/#{path}").with(headers: headers, body: body)
    end

    def api_request_headers(extra = {}, unauthenticated = false)
      headers = {
        'Accept'          => 'application/json',
        'Accept-Charset'  => 'utf-8',
        'Authorization'   => 'Bearer access-token',
        'Content-Type'    => 'application/json',
        'User-Agent'      => 'Climbcomp'
      }.merge(extra)
      unauthenticated ? headers.except('Authorization') : headers
    end

    def api_response(data: {}, status: 200)
      {
        body: data.to_json,
        headers: {
          'Content-Type' => 'application/json'
        },
        status: status
      }
    end

  end

end
