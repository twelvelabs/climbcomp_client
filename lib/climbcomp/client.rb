# frozen_string_literal: true

module Climbcomp
  class Client

    attr_accessor :config

    def initialize(config: Climbcomp.config)
      @config = config
    end

  end
end
