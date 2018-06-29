# frozen_string_literal: true

require 'test_helper'
require 'fileutils'

class StoreTest < Climbcomp::Spec

  describe Climbcomp::Store do

    # Note: `config_dir` gets auto removed in `Climbcomp::Spec` before/after hooks
    let(:storage_dir) { config_dir }
    let(:storage_path) { config_path('storage.yml') }

    it 'should create storage_dir if needed' do
      assert_equal false, Dir.exist?(storage_dir)
      Climbcomp::Store.new(storage_path)
      assert_equal true, Dir.exist?(storage_dir)
      assert_equal '700', posix_permissions(storage_dir)
    end

    it 'should create storage_path if needed' do
      assert_equal false, File.exist?(storage_path)
      Climbcomp::Store.new(storage_path)
      assert_equal true, File.exist?(storage_path)
      assert_equal '600', posix_permissions(storage_path)
      assert_equal '', File.read(storage_path)
    end

    it 'should update permissions if needed' do
      Dir.mkdir(storage_dir)
      File.write(storage_path, '')
      File.chmod(0o777, storage_dir)
      File.chmod(0o777, storage_path)
      Climbcomp::Store.new(storage_path)
      assert_equal '700', posix_permissions(storage_dir)
      assert_equal '600', posix_permissions(storage_path)
    end

    it 'should return a slice' do
      store = Climbcomp::Store.new(storage_path)
      store.insert(alpha: 'a', bravo: 'b', charlie: 'c')
      assert_equal %i[alpha bravo], store.slice(:alpha, :bravo).keys.sort
      assert_equal %i[alpha],       store.slice(:alpha, :delta).keys.sort
      assert_equal [],              store.slice(:delta, :echo).keys.sort
    end

    it 'should return a slice if all are present' do
      store = Climbcomp::Store.new(storage_path)
      store.insert(alpha: 'a', bravo: 'b', charlie: '')
      assert_equal %i[alpha bravo], store.presence(:alpha, :bravo).keys.sort
      # if _any_ key is either missing or blank, return `nil`
      assert_nil store.presence(:alpha, :bravo, :charlie)
      assert_nil store.presence(:alpha, :delta)
      assert_nil store.presence(:delta, :echo)
    end

    it 'should auto-convert string keys to symbols' do
      store = Climbcomp::Store.new(storage_path)
      store.insert('alpha' => 'a', 'bravo' => 'b', 'charlie' => 'c')
      assert_equal('a', store.transaction { |s| s[:alpha] })
    end

    it 'should bulk insert hashes' do
      store = Climbcomp::Store.new(storage_path)
      store.insert(alpha: 'a')
      assert_equal true, store.include?(:alpha)
      store.insert(alpha: 'A', bravo: 'B')
      assert_equal('A', store.transaction { |s| s[:alpha] })
      assert_equal('B', store.transaction { |s| s[:bravo] })
    end

    it 'should clear' do
      store = Climbcomp::Store.new(storage_path)
      store.insert(alpha: 'a', bravo: 'b')
      assert_equal true, store.include?(:alpha, :bravo)
      store.clear
      assert_equal false, store.include?(:alpha)
      assert_equal false, store.include?(:bravo)
    end

    it 'should tell whether key/value pairs are present' do
      store = Climbcomp::Store.new(storage_path)
      store.insert(alpha: 'a', bravo: 'b', charlie: '')
      assert_equal true, store.present?(:alpha)
      assert_equal true, store.present?(:alpha, :bravo)
      assert_equal false, store.present?(:alpha, :bravo, :charlie)
      assert_equal false, store.present?(:delta)
    end

  end

  def posix_permissions(path)
    # lol, why isn't this easier in stdlib
    File.stat(path).mode.to_s(8).chars.last(3).join
  end

end
