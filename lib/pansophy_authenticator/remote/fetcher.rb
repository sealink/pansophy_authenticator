require 'pansophy'

module PansophyAuthenticator
  module Remote
    class Fetcher

      def keys
        @keys ||= fetch
      end
      
      private

      def fetch
        Pansophy.read(configuration.bucket_name, configuration.file_path)
      end

      def configuration
        PansophyAuthenticator.configuration
      end
    end
  end
end
