# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'climbcomp'
require 'climbcomp/cli'
require 'climbcomp/command'

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'

# Webmock is requiring `addressable`, which is generating a warning in Ruby 2.5.
# It's apparently fixed in master, but they have yet to release a new gem version :(
# Suppressing warnings until they do because I get twitchy when there's spam in my test output.
silence_warnings do
  require 'webmock/minitest'
end

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

module Climbcomp
  class Spec < Minitest::Spec

    # Ensure config dir is always cleared out between test runs.
    before do
      FileUtils.remove_dir(config_dir) if Dir.exist?(config_dir)
      Climbcomp.configure do |c|
        c.client_store_path = config_path('oauth2-client.yml')
        c.token_store_path  = config_path('oauth2-token.yml')
      end
    end

    after do
      Climbcomp.reset!
      FileUtils.remove_dir(config_dir) if Dir.exist?(config_dir)
    end

    def config_dir
      File.join(Dir.tmpdir, 'climbcomp-test')
    end

    def config_path(filename)
      File.join(config_dir, filename)
    end

    def write_yaml(path, content)
      # Ensure dir
      dir = File.dirname(path)
      Dir.mkdir(dir) unless Dir.exist?(dir)
      File.write(path, content.to_yaml)
    end

    def write_token_yaml
      write_yaml(
        config_path('oauth2-token.yml'),
        client_id:      'client_id',
        client_secret:  'client_secret',
        access_token:   'access_token',
        id_token:       'id_token',
        refresh_token:  'refresh_token',
        expires_at:     'expires_at',
        expires_in:     'expires_in'
      )
    end

  end
end
