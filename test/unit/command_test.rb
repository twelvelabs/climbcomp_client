# frozen_string_literal: true

require 'test_helper'

class CommandTest < Climbcomp::Spec

  describe Climbcomp::Command do

    let(:options) do
      {
        foo: 'bar'
      }
    end
    let(:command) { Climbcomp::Command.new(options) }

    it 'should have options' do
      assert_equal 'bar', command.options[:foo]
    end

  end

end
