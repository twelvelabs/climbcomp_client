# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'climbcomp'

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

module Climbcomp
  class Spec < Minitest::Spec

    # Ensure config dir is always cleared out between test runs.
    before do
      FileUtils.remove_dir(config_dir) if Dir.exist?(config_dir)
    end

    after do
      FileUtils.remove_dir(config_dir) if Dir.exist?(config_dir)
    end

    def config_dir
      File.join(Dir.tmpdir, 'climbcomp-test')
    end

    def config_path(filename)
      File.join(config_dir, filename)
    end

  end
end
