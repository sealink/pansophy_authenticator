require 'singleton'
require 'memoizable'
require 'pansophy'

module PansophyAuthenticator
  module Remote
    class ApplicationKeys
      include Singleton
      include Memoizable

      def keys
        Pansophy.read(configuration.bucket_name, configuration.file_path)
      end
      memoize :keys

      private

      def configuration
        PansophyAuthenticator.configuration
      end
    end
  end
end
