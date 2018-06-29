# frozen_string_literal: true

require 'test_helper'

class CommandTest < Climbcomp::Spec

  describe Climbcomp::Client do

    it 'should use the default config if none passed' do
      config = Climbcomp.config
      client = Climbcomp::Client.new
      assert_equal config, client.config
    end

    it 'should accept a custom config' do
      config = Climbcomp::Configuration.new(oidc_client_id: 'custom')
      client = Climbcomp::Client.new(config: config)
      assert_equal config, client.config
      assert_equal 'custom', client.config.oidc_client_id
    end

  end

end
