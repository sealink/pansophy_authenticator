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

  def self.own_key
    ApplicationKeys.own
  end

  %i(key valid? validate!).each do |method|
    define_singleton_method(method) { |*args| ApplicationKeys.send(method, *args) }
  end

  class Error < StandardError; end
end

require 'pansophy_authenticator/configuration'
require 'pansophy_authenticator/application_keys'
require 'pansophy_authenticator/matcher'
require 'pansophy_authenticator/local'
require 'pansophy_authenticator/remote'
