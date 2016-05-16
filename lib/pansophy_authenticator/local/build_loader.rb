require 'memoizable'
require 'yamload'

module PansophyAuthenticator
  module Local
    class BuildLoader
      include Memoizable

      def call
        Yamload::Loader.new(filename, dirname)
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

      def configuration
        PansophyAuthenticator.valid_configuration
      end
    end
  end
end
