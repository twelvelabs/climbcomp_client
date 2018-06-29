# frozen_string_literal: true

require 'test_helper'

class OAuth2TokenFactoryTest < Climbcomp::Spec

  describe Climbcomp::OAuth2::TokenFactory do

    let(:attributes) do
      {
        client_id:      'test_client_id',
        client_secret:  'test_client_secret',
        access_token:   'test_access_token',
        id_token:       'test_id_token',
        refresh_token:  'test_refresh_token',
        expires_at:     '12345'
      }
    end

    it 'should create an oauth token' do
      token = Climbcomp::OAuth2::TokenFactory.create(attributes)
      assert_instance_of ::OAuth2::AccessToken, token
      assert_equal 'test_client_id',      token.client.id
      assert_equal 'test_client_secret',  token.client.secret
      assert_equal 'test_access_token',   token.token
      assert_equal 'test_id_token',       token[:id_token]
      assert_equal 'test_refresh_token',  token.refresh_token
      assert_equal 12_345,                token.expires_at
    end

  end

end
