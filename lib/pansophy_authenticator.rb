require 'pansophy_authenticator/version'

module PansophyAuthenticator
  def self.configure
    configurator = Configuration::Configurator.new
    yield configurator if block_given?
    @configuration = configurator.configuration
  end

  def self.configuration
    @configuration ||= configure
  end

  def self.remote?
    configuration.remote?
  end

  class Error < StandardError; end
end

require 'pansophy_authenticator/configuration'
