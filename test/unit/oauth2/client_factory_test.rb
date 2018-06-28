# frozen_string_literal: true

require 'test_helper'

class OAuth2ClientFactoryTest < Climbcomp::Spec

  describe Climbcomp::OAuth2::ClientFactory do

    let(:attributes) do
      {
        client_id:      '1234',
        client_secret:  'abcd'
      }
    end

    it 'should create an oauth client' do
      client = Climbcomp::OAuth2::ClientFactory.create(attributes)
      assert_instance_of ::OAuth2::Client, client
      assert_equal '1234', client.id
      assert_equal 'abcd', client.secret
      assert_equal Climbcomp.config.oidc_issuer,                  client.site
      assert_equal Climbcomp.config.oidc_authorization_endpoint,  client.options[:authorize_url]
      assert_equal Climbcomp.config.oidc_token_endpoint,          client.options[:token_url]
    end

    it 'should raise if client id or secret missing' do
      assert_raises(ArgumentError) { Climbcomp::OAuth2::ClientFactory.create(client_id: 'foo', client_secret: '') }
      assert_raises(ArgumentError) { Climbcomp::OAuth2::ClientFactory.create(client_id: '', client_secret: 'foo') }
      assert_raises(ArgumentError) { Climbcomp::OAuth2::ClientFactory.create(client_id: '', client_secret: '') }
    end

  end

end
