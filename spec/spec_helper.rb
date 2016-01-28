$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  config.before :suite do
    # -- Configure yamload --
    Yamload.dir = Pathname.new(__FILE__).expand_path.dirname
  end
end

require 'pansophy_authenticator'
