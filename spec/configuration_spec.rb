require 'spec_helper'

describe PansophyAuthenticator do
  context 'its configuration' do
    shared_examples 'a configuration via environment variables' do
      context 'when environment variables are set' do
        before do
          ENV['PANSOPHY_AUTHENTICATOR_LOCAL']       = 'true'
          ENV['PANSOPHY_AUTHENTICATOR_BUCKET_NAME'] = 'none'
          ENV['PANSOPHY_AUTHENTICATOR_FILE_PATH']   = 'local_app_keys.yml'
        end

        after do
          ENV['PANSOPHY_AUTHENTICATOR_LOCAL']       = nil
          ENV['PANSOPHY_AUTHENTICATOR_BUCKET_NAME'] = nil
          ENV['PANSOPHY_AUTHENTICATOR_FILE_PATH']   = nil
        end

        it { is_expected.to be_local }
        specify { expect(configuration.bucket_name).to eq 'none' }
        specify { expect(configuration.file_path).to eq 'local_app_keys.yml' }
      end
    end

    shared_examples 'a configured configuration' do
      context 'when environment variables are not set' do
        it { is_expected.to be_remote }
        specify { expect(configuration.bucket_name).to eq bucket_name }
        specify { expect(configuration.file_path).to eq file_path }
      end

      it_behaves_like 'a configuration via environment variables'
    end


    context 'when not configured' do
      subject(:configuration) { PansophyAuthenticator.configure }

      context 'when environment variables are not set' do
        it { is_expected.to be_remote }
        specify { expect(configuration.bucket_name).to be_nil }
        specify { expect(configuration.file_path).to be_nil }
      end

      it_behaves_like 'a configuration via environment variables'
    end

    context 'when configured' do
      let(:local) { false }
      let(:bucket_name) { 'test' }
      let(:file_path) { 'config/app_keys.yml' }

      context 'without a configuration path' do
        subject(:configuration) {
          PansophyAuthenticator.configure do |configuration|
            configuration.local       = local
            configuration.bucket_name = bucket_name
            configuration.file_path   = file_path
          end
        }

        it_behaves_like 'a configured configuration'
      end

      context 'with a configuration path' do
        subject(:configuration) {
          PansophyAuthenticator.configure do |configuration|
            configuration.configuration_path = configuration_path
          end
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
          let(:file_path) { 'custom_config/custom_app_keys.yml' }
          it_behaves_like 'a configured configuration'
        end
      end
    end
  end
end
