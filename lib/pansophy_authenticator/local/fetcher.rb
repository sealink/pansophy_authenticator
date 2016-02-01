require 'singleton'
require 'memoizable'
require 'yamload'

module PansophyAuthenticator
  module Local
    class Fetcher
      include Singleton
      include Memoizable

      def keys
        content
      end

      private

      def pathname
        Pathname.new(configuration.file_path)
      end
      memoize :pathname

      def dirname
        pathname.dirname
      end

      def filename
        pathname.basename('.yml')
      end

      def content
        loader.content
      end
      memoize :content

      def loader
        Yamload::Loader.new(filename, dirname)
      end

      def configuration
        PansophyAuthenticator.configuration
      end
    end
  end
end
