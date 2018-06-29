# frozen_string_literal: true

require 'test_helper'
require 'climbcomp/commands/config'

class ConfigTest < Climbcomp::Spec

  describe Climbcomp::Commands::Config do

    let(:input)   { StringIO.new }
    let(:output)  { StringIO.new }
    let(:options) do
      {}
    end
    let(:command) { Climbcomp::Commands::Config.new(options) }

    # TODO: figure out a good way to test this
    it 'should exist' do
      assert command
    end

  end

end
