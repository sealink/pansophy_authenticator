$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'support/coverage_loader'

RSpec.configure do |config|
  # Ensure that no system environment variables can influence the tests
  config.before do
    ENV.delete 'PANSOPHY_AUTHENTICATOR_LOCAL'
    ENV.delete 'PANSOPHY_AUTHENTICATOR_BUCKET_NAME'
    ENV.delete 'PANSOPHY_AUTHENTICATOR_FILE_PATH'
    ENV.delete 'PANSOPHY_AUTHENTICATOR_APPLICATION'
  end
end

require 'pansophy_authenticator'
