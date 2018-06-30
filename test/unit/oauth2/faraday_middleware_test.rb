# frozen_string_literal: true

require 'test_helper'

class OAuth2FaradayMiddlewareTest < Climbcomp::Spec

  describe Climbcomp::OAuth2::FaradayMiddleware do

    let(:token_values) do
      {
        client_id:      'test_client_id',
        client_secret:  'test_client_secret',
        access_token:   'OLD_access_token',
        id_token:       'OLD_id_token',
        refresh_token:  'test_refresh_token',
        expires_at:     '12345'
      }
    end
    let(:refreshed_values) do
      {
        client_id:      'test_client_id',
        client_secret:  'test_client_secret',
        access_token:   'NEW_access_token',
        id_token:       'NEW_id_token',
        refresh_token:  'test_refresh_token',
        expires_at:     '23456'
      }
    end
    let(:env) do
      Faraday::Env.from(
        url:              URI('http://example.com/'),
        request_headers:  Faraday::Utils::Headers.new
      )
    end
    let(:app)         { ->(e) { e } } # root app just returns the env when called
    let(:middleware)  { Climbcomp::OAuth2::FaradayMiddleware.new(app, Climbcomp.config) }

    it 'should not add auth header if token missing' do
      e = middleware.call(env)
      assert_nil e[:request_headers]['Authorization']
    end

    it 'should add auth header if token present' do
      Climbcomp.config.token = Climbcomp::OAuth2::TokenFactory.create(token_values)
      Climbcomp.config.token.expects(:expired?).returns(false)
      e = middleware.call(env)
      assert_equal 'Bearer OLD_access_token', e[:request_headers]['Authorization']
      assert_equal 'OLD_access_token', Climbcomp.config.token.token
    end

    it 'should refresh if token expired' do
      refreshed = Climbcomp::OAuth2::TokenFactory.create(refreshed_values)
      Climbcomp.config.token = Climbcomp::OAuth2::TokenFactory.create(token_values)
      Climbcomp.config.token.expects(:expired?).returns(true)
      Climbcomp.config.token.expects(:refresh).returns(refreshed)
      e = middleware.call(env)
      assert_equal 'Bearer NEW_access_token', e[:request_headers]['Authorization']
      assert_equal 'NEW_access_token', Climbcomp.config.token.token
    end

  end

end
