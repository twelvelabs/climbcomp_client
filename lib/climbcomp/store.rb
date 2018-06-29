# frozen_string_literal: true

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

    def clear
      transaction do
        roots.each { |k| delete(k) }
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
      return nil unless present?(*keys)
      slice(*keys)
    end

    # True if all keys exist in the store and are non-empty.
    def present?(*keys)
      transaction(true) do
        keys.all? { |k| root?(k) && self[k].present? }
      end
    end

    # True if all keys exist in the store (regardless of their values).
    def include?(*keys)
      transaction(true) do
        keys.all? { |k| root?(k) }
      end
    end

  end
end
