require 'spec_helper'

describe PansophyAuthenticator::Config do

  subject(:config) { PansophyAuthenticator::Config }

  context 'when environment variables are not set' do
    it { is_expected.not_to be_local }
    specify { expect(config.bucket_name).to eq 'test' }
    specify { expect(config.file_path).to eq 'config/app_keys.yml' }
  end

  context 'when environment variables are set' do
    before do
      ENV['PANSOPHY_AUTHENTICATOR_LOCAL'] = 'true'
      ENV['PANSOPHY_AUTHENTICATOR_BUCKET_NAME'] = 'none'
      ENV['PANSOPHY_AUTHENTICATOR_FILE_PATH'] = 'local_app_keys.yml'
    end

    it { is_expected.to be_local }
    specify { expect(config.bucket_name).to eq 'none' }
    specify { expect(config.file_path).to eq 'local_app_keys.yml' }
  end
end