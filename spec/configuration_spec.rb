require 'spec_helper'

describe PansophyAuthenticator do
  context 'its configuration' do
    subject(:configuration)   { PansophyAuthenticator.configuration }
    let(:configuration_block) { ->(_configuration) {} }

    shared_examples 'a configuration via environment variables' do
      let(:local)       { 'true' }
      let(:bucket_name) { 'none' }
      let(:file_path)   { 'local_app_keys.yml' }
      let(:application) { 'my_app' }

      before do
        ENV['PANSOPHY_AUTHENTICATOR_LOCAL']       = local
        ENV['PANSOPHY_AUTHENTICATOR_BUCKET_NAME'] = bucket_name
        ENV['PANSOPHY_AUTHENTICATOR_FILE_PATH']   = file_path
        ENV['PANSOPHY_AUTHENTICATOR_APPLICATION'] = application
      end

      before do
        PansophyAuthenticator.configure &configuration_block
      end

      after do
        ENV['PANSOPHY_AUTHENTICATOR_LOCAL']       = nil
        ENV['PANSOPHY_AUTHENTICATOR_BUCKET_NAME'] = nil
        ENV['PANSOPHY_AUTHENTICATOR_FILE_PATH']   = nil
        ENV['PANSOPHY_AUTHENTICATOR_APPLICATION'] = nil
      end

      specify { expect(PansophyAuthenticator).not_to be_remote }
      it { is_expected.to be_local }
      specify { expect(configuration.bucket_name).to eq bucket_name }
      specify { expect(configuration.file_path).to eq file_path }
      specify { expect(configuration.application).to eq application }
    end

    shared_examples 'a configured configuration' do
      context 'when environment variables are not set' do
        specify { expect(PansophyAuthenticator).to be_remote }
        it { is_expected.to be_remote }
        specify { expect(configuration.bucket_name).to eq bucket_name }
        specify { expect(configuration.file_path).to eq file_path }
        specify { expect(configuration.application).to eq application }
      end

      context 'when environment variables are set' do
        it_behaves_like 'a configuration via environment variables'
      end
    end

    before do
      PansophyAuthenticator.configure &configuration_block
    end

    context 'when not configured' do
      context 'when environment variables are not set' do
        it { is_expected.to be_remote }
        specify { expect(configuration.bucket_name).to be_nil }
        specify { expect(configuration.file_path).to be_nil }
        specify { expect(configuration.application).to be_nil }
      end

      context 'when environment variables are set' do
        it_behaves_like 'a configuration via environment variables'
      end
    end

    context 'when configured' do
      let(:local)       { false }
      let(:bucket_name) { 'test' }
      let(:file_path)   { 'config/app_keys.yml' }
      let(:application) { 'my_app' }

      context 'without a configuration path' do
        let(:configuration_block) {
          ->(configuration) {
            configuration.local       = local
            configuration.bucket_name = bucket_name
            configuration.file_path   = file_path
            configuration.application = application
          }
        }

        it_behaves_like 'a configured configuration'
      end

      context 'with a configuration path' do
        let(:configuration_block) {
          ->(configuration) {
            configuration.configuration_path = configuration_path
          }
        }

        context 'with a configuration folder' do
          let(:configuration_path) { Pathname.new(__FILE__).expand_path.dirname }
          it_behaves_like 'a configured configuration'
        end

        context 'with a configuration file' do
          let(:configuration_path) {
            Pathname.new(__FILE__).expand_path.dirname
              .join('configuration_test')
              .join('custom_config.yml')
          }
          let(:bucket_name) { 'custom' }
          let(:file_path)   { 'custom_config/custom_app_keys.yml' }
          let(:application) { 'custom_app' }
          it_behaves_like 'a configured configuration'
        end
      end

      context 'with a cache store' do
        let(:cache_store) { double }
        let(:configuration_block) {
          ->(configuration) {
            configuration.cache_store = cache_store
          }
        }
        specify { expect(configuration.cache_store).to be cache_store }
      end

      context 'without a cache store' do
        let(:cache_store) { PansophyAuthenticator::CacheStores::Memory }
        specify { expect(configuration.cache_store).to be_a cache_store }
      end
    end
  end
end
