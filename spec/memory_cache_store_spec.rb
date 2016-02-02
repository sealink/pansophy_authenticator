# rubocop:disable Style/BlockDelimiters

require 'spec_helper'

describe PansophyAuthenticator::CacheStores::Memory do
  subject(:cache_store) { PansophyAuthenticator::CacheStores::Memory.new }

  let(:cache_key) { 'test_key' }
  let(:cache_value) { 'test_value' }

  let(:read)   { cache_store.read(cache_key) }
  let(:write)  { cache_store.write(cache_key, cache_value) }
  let(:delete) { cache_store.delete(cache_key) }
  let(:exist?) { cache_store.exist?(cache_key) }

  context 'when the value is not cached' do
    specify { expect(exist?).to be false }
    specify { expect(read).to be_nil }
  end

  context 'when the value is cached' do
    before do
      write
    end

    specify { expect(exist?).to be true }
    specify { expect(read).to eq cache_value }

    context 'when the value is deleted' do
      before do
        delete
      end

      specify { expect(exist?).to be false }
      specify { expect(read).to be_nil }
    end
  end
end
