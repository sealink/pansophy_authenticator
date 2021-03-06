# frozen_string_literal: true
require 'memoizable'
require 'yamload'

module PansophyAuthenticator
  module Configuration
    class FromFile
      include Memoizable

      DEFAULT_FILENAME = 'pansophy_authenticator'.freeze

      def initialize(base_configuration)
        @base_configuration = base_configuration
      end

      def local
        content.fetch('local') { @base_configuration.local }
      end

      def bucket_name
        content.fetch('bucket_name') { @base_configuration.bucket_name }
      end

      def file_path
        content.fetch('file_path') { @base_configuration.file_path }
      end

      def application
        content.fetch('application') { @base_configuration.application }
      end

      private

      def pathname
        Pathname.new(@base_configuration.configuration_path)
      end
      memoize :pathname

      def dirname
        return pathname if pathname.directory?
        pathname.dirname
      end
      memoize :dirname

      def filename
        return Pathname.new(DEFAULT_FILENAME) if pathname.directory?
        pathname.basename('.yml')
      end
      memoize :filename

      def content
        loader.content
      end
      memoize :content

      def loader
        Yamload::Loader.new(filename, dirname)
      end
    end
  end
end
