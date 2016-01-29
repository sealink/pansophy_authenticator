require 'spec_helper'

describe PansophyAuthenticator::ApplicationKeys do
  before do
    PansophyAuthenticator.configure do |configuration|
      configuration.local       = local
      configuration.bucket_name = bucket_name
      configuration.file_path   = file_path
      configuration.application = local_application
    end
  end

  let(:bucket_name)        { 'test_bucket' }
  let(:file_path)          { 'app_keys.yml' }
  let(:local_application)  { 'local_app' }
  let(:remote_application) { 'remote_app' }

  let(:local_app_key)  { 'a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5' }
  let(:remote_app_key) { '5d4c3b2a1f0e9d8c7b6a5f4e3d2c1b0a' }

  shared_examples 'an application key authenticator' do
    context 'when retrieving the key of the local application' do
      subject(:own_key) { PansophyAuthenticator::ApplicationKeys.own }

      context 'if the application is defined in the keys file' do
        it { is_expected.to eq local_app_key }
      end

      context 'if the application is not defined in the keys file' do
        let(:local_application)  { 'wrong_app' }
        let(:error_message) { "#{local_application} is not defined" }
        specify { expect { own_key }.to raise_error PansophyAuthenticator::Error, error_message }
      end
    end

    context 'when retrieving the key of the remote application' do
      subject(:remote_key) { PansophyAuthenticator::ApplicationKeys.key(remote_application) }

      context 'if the application is defined in the keys file' do
        it { is_expected.to eq remote_app_key }
      end

      context 'if the application is not defined in the keys file' do
        let(:remote_application)  { 'wrong_app' }
        let(:error_message) { "#{remote_application} is not defined" }
        specify { expect { remote_key }.to raise_error PansophyAuthenticator::Error, error_message }
      end
    end

    context 'when checking the validity of the key of the remote application' do
      let(:application_keys) { PansophyAuthenticator::ApplicationKeys }
      subject(:valid) { application_keys.valid?(remote_application, remote_app_key) }

      context 'if the application is defined in the keys file' do
        context 'and the key matches' do
          it { is_expected.to be true }
        end

        context 'and the key does not match' do
          let(:remote_app_key) { 'wrong_key' }
          it { is_expected.to be false }
        end
      end

      context 'if the application is not defined in the keys file' do
        let(:remote_application)  { 'wrong_app' }
        let(:error_message) { "#{remote_application} is not defined" }
        specify { expect { valid }.to raise_error PansophyAuthenticator::Error, error_message }
      end
    end

    context 'when validating the key of the remote application' do
      let(:application_keys) { PansophyAuthenticator::ApplicationKeys }
      subject(:validate) { application_keys.validate!(remote_application, remote_app_key) }

      context 'if the application is defined in the keys file' do
        context 'and the key matches' do
          specify { expect { validate }.not_to raise_error }
        end

        context 'and the key does not match' do
          let(:remote_app_key) { 'wrong_key' }
          let(:error_message) { "Invalid key for #{remote_application}" }
          specify { expect { validate }.to raise_error PansophyAuthenticator::Error, error_message }
        end
      end

      context 'if the application is not defined in the keys file' do
        let(:remote_application)  { 'wrong_app' }
        let(:error_message) { "#{remote_application} is not defined" }
        specify { expect { validate }.to raise_error PansophyAuthenticator::Error, error_message }
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
    let(:remote_content) {
      {
        local_application => local_app_key,
        remote_application => remote_app_key
      }
    }

    before do
      stub_const('Pansophy', pansophy)
      allow(pansophy).to receive(:read).with(bucket_name, file_path).and_return(remote_content)
    end

    it_behaves_like 'an application key authenticator'
  end
end
