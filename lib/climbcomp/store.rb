# frozen_string_literal: true

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/blank'
require 'yaml/store'

module Climbcomp
  class Store < YAML::Store

    # Lazily create storage path if needed, and ensure correct permissions.
    def initialize(*args)
      path  = args[0]
      dir   = File.dirname(path)
      # ensure dir
      FileUtils.mkdir_p(dir)
      File.chmod(0o700, dir)
      # ensure file
      File.write(path, '') unless File.exist?(path)
      File.chmod(0o600, path)
      super(*args)
    end

    # Ensures top level keys are always symbols.
    # Note: not deep symbolizing, so subkeys will remain as-is.
    def load(content)
      table = super(content)
      table.symbolize_keys
    end

    def insert(hash)
      transaction do
        hash.each { |k, v| self[k.to_sym] = v }
      end
    end

    # Similar to Hash#slice: returns a hash w/ all `keys` present in the store.
    def slice(*keys)
      transaction(true) do
        keys.each_with_object({}) { |k, hash| hash[k] = self[k] if root?(k) }
      end
    end

    # A fusion of `Hash#slice` and `Object#presence` (from ActiveSupport).
    # If all keys are in the store, and all values are non-empty,
    # returns a slice containing those keys (otherwise returns nil).
    def presence(*keys)
      hash = slice(*keys)
      return nil unless hash.keys.sort == keys.sort
      hash.values.each do |v|
        return nil if v.blank?
      end
      hash
    end

  end
end
