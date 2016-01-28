require 'singleton'
require 'memoize'
require 'yamload'

module PansophyAuthenticator
  class Config
    include Singleton
    include Memoizable

    class << self
      %i(local? remote? bucket_name file_path).each do |method|
        define_method(method) { |*args| instance.send(method, *args) }
      end
    end

    def local?
      local = ENV.fetch('PANSOPHY_AUTHENTICATOR_LOCAL') { content.fetch('local', false) }
      return true if local == 'true'
      local
    end

    def remote?
      !local?
    end

    def bucket_name
      ENV.fetch('PANSOPHY_AUTHENTICATOR_BUCKET_NAME') { content.fetch('bucket_name') }
    end

    def file_path
      ENV.fetch('PANSOPHY_AUTHENTICATOR_FILE_PATH') { content.fetch('file_path') }
    end

    private

    def content
      loader.content
    end
    memoize :content

    def loader
      Yamload::Loader.new(:pansophy_authenticator)
    end
  end
end