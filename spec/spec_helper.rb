$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

MINIMUM_COVERAGE = 100

unless ENV['COVERAGE'] == 'off'
  require 'simplecov'
  require 'simplecov-rcov'
  require 'coveralls'
  Coveralls.wear!

  SimpleCov.formatters = [
    SimpleCov::Formatter::RcovFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter '/vendor/'
    add_filter '/spec/'
    add_group 'lib', 'lib'
  end
  SimpleCov.at_exit do
    SimpleCov.result.format!
    percent = SimpleCov.result.covered_percent
    unless percent >= MINIMUM_COVERAGE
      puts "Coverage must be above #{MINIMUM_COVERAGE}%. It is #{format('%.2f', percent)}%"
      Kernel.exit(1)
    end
  end
end

RSpec.configure do |config|
  # Ensure that no environment variables from the system can influence the tests
  config.before do
    ENV.delete 'PANSOPHY_AUTHENTICATOR_LOCAL'
    ENV.delete 'PANSOPHY_AUTHENTICATOR_BUCKET_NAME'
    ENV.delete 'PANSOPHY_AUTHENTICATOR_FILE_PATH'
    ENV.delete 'PANSOPHY_AUTHENTICATOR_APPLICATION'
  end
end

require 'pansophy_authenticator'
