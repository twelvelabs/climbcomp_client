# frozen_string_literal: true

require 'test_helper'

class ClimbcompTest < Climbcomp::Spec

  describe Climbcomp do

    it 'should have a global config' do
      config = Climbcomp.config
      assert_instance_of Climbcomp::Configuration, config
      assert_equal config, Climbcomp.config
    end

    it 'should allow configuring via block' do
      assert_equal '/authorize', Climbcomp.config.oidc_authorization_endpoint
      Climbcomp.configure do |c|
        c.oidc_authorization_endpoint = '/foo'
      end
      assert_equal '/foo', Climbcomp.config.oidc_authorization_endpoint
    end

    it 'should have a global client' do
      client = Climbcomp.client
      assert_instance_of Climbcomp::Client, client
      assert_equal Climbcomp.config, client.config
    end

    it 'should reset to default state' do
      Climbcomp.configure do |c|
        c.oidc_authorization_endpoint = '/foo'
      end
      assert_equal '/foo', Climbcomp.config.oidc_authorization_endpoint
      assert_equal '/foo', Climbcomp.client.config.oidc_authorization_endpoint
      Climbcomp.reset!
      assert_equal '/authorize', Climbcomp.config.oidc_authorization_endpoint
      assert_equal '/authorize', Climbcomp.client.config.oidc_authorization_endpoint
    end

  end

end
