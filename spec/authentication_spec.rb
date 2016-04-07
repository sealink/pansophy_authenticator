# rubocop:disable Style/BlockDelimiters

require 'spec_helper'

describe PansophyAuthenticator do
  before do
    PansophyAuthenticator.configure do |configuration|
      configuration.local       = local
      configuration.bucket_name = bucket_name
      configuration.file_path   = file_path
      configuration.application = local_application
      configuration.cache_store = cache_store
    end
  end

  let(:bucket_name)        { 'test_bucket' }
  let(:file_path)          { 'app_keys.yml' }
  let(:cache_store)        { nil }

  let(:app_keys) {
    {
      'local_app'  => 'a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5',
      'remote_app' => '5d4c3b2a1f0e9d8c7b6a5f4e3d2c1b0a'
    }
  }

  let(:local_application)  { app_keys.keys[0] }
  let(:remote_application) { app_keys.keys[1] }

  let(:local_app_key)  { app_keys['local_app'] }
  let(:remote_app_key) { app_keys['remote_app'] }

  shared_examples 'an application key authenticator' do
    context 'when retrieving the key of the local application' do
      subject(:own_key) { PansophyAuthenticator.own_key }

      context 'if the application is defined in the keys file' do
        it { is_expected.to eq local_app_key }
      end

      context 'if the application is not defined in the keys file' do
        let(:local_application) { 'wrong_app' }
        let(:error_message) { "#{local_application} is not defined" }
        specify { expect { own_key }.to raise_error PansophyAuthenticator::Error, error_message }
      end

      context 'when relying on a cache store' do
        let(:caching_action) { own_key }
        it_behaves_like 'it relies on a cache store'
      end
    end

    context 'when retrieving the key of the remote application' do
      subject(:remote_key) { PansophyAuthenticator.key(remote_application) }

      context 'if the application is defined in the keys file' do
        it { is_expected.to eq remote_app_key }
      end

      context 'if the application is not defined in the keys file' do
        let(:remote_application)  { 'wrong_app' }
        let(:error_message) { "#{remote_application} is not defined" }
        specify { expect { remote_key }.to raise_error PansophyAuthenticator::Error, error_message }
      end

      context 'when relying on a cache store' do
        let(:caching_action) { remote_key }
        it_behaves_like 'it relies on a cache store'
      end
    end

    context 'when checking the validity of the key of the remote application' do
      let(:pansophy_authenticator) { PansophyAuthenticator }
      subject(:valid) { pansophy_authenticator.valid?(remote_application, remote_app_key) }

      context 'if the application is defined in the keys file' do
        context 'and the key matches' do
          it { is_expected.to be true }
        end

        context 'and the key does not match' do
          let(:remote_app_key) { 'wrong_key' }
          it { is_expected.to be false }
        end

        context 'when relying on a cache store' do
          let(:caching_action) { valid }
          it_behaves_like 'it relies on a cache store'
        end
      end

      context 'if the application is not defined in the keys file' do
        let(:remote_application)  { 'wrong_app' }
        specify { expect(valid).to be false }
      end
    end

    context 'when validating the key of the remote application' do
      let(:pansophy_authenticator) { PansophyAuthenticator }
      subject(:validate) {
        pansophy_authenticator.authenticate!(remote_application, remote_app_key)
      }

      context 'if the application is defined in the keys file' do
        context 'and the key matches' do
          specify { expect { validate }.not_to raise_error }
        end

        context 'and the key does not match' do
          let(:remote_app_key) { 'wrong_key' }
          let(:error_message) { 'Invalid application or key' }
          specify { expect { validate }.to raise_error PansophyAuthenticator::Error, error_message }
        end
      end

      context 'if the application is not defined in the keys file' do
        let(:remote_application)  { 'wrong_app' }
        let(:error_message) { 'Invalid application or key' }
        specify { expect { validate }.to raise_error PansophyAuthenticator::Error, error_message }
      end

      context 'when relying on a cache store' do
        let(:caching_action) { validate }
        it_behaves_like 'it relies on a cache store'
      end
    end
  end

  shared_examples 'it relies on a cache store' do
    let(:cache_key)     { PansophyAuthenticator::Cache::CACHE_KEY }
    let(:cache_store)   { double('test_cache_store') }
    let(:cached_values) { {} }
    let(:json_app_keys) { JSON.dump(app_keys) }

    before do
      allow(cache_store).to receive(:exist?) { |key| cached_values.key? key }
      allow(cache_store).to receive(:read)   { |key| cached_values[key] }
      allow(cache_store).to receive(:write)  { |key, value| cached_values[key] = value }
      allow(cache_store).to receive(:delete) { |key| cached_values.delete(key) }
    end

    let(:cache_app_keys) { cached_values[cache_key] = json_app_keys }

    before do
      cache_app_keys if cached
      caching_action
    end

    context 'when the keys are not cached' do
      let(:cached) { false }
      specify { expect(cache_store).to have_received(:write).once.with(cache_key, json_app_keys) }
    end

    context 'when the keys are cached' do
      let(:cached) { true }
      specify { expect(cache_store).not_to have_received(:write) }

      context 'when the cache is cleared' do
        before do
          PansophyAuthenticator.clear_cached_keys
        end
        specify { expect(cache_store).to have_received(:delete).with(cache_key) }
      end
    end
  end

  context 'when PansophyAuthenticator is configured as local' do
    let(:local) { true }
    let(:file_path) { Pathname.new(__FILE__).expand_path.dirname.join(super()) }

    it_behaves_like 'an application key authenticator'
  end

  context 'when PansophyAuthenticator is configured as remote' do
    let(:local) { false }
    let(:file_path) { Pathname.new('config').expand_path.join(super()) }

    let(:pansophy) { double }
    let(:app_keys_yaml) { YAML.dump app_keys }

    before do
      stub_const('Pansophy', pansophy)
      allow(pansophy).to receive(:read).with(bucket_name, file_path).and_return(app_keys_yaml)
    end

    it_behaves_like 'an application key authenticator'
  end
end
