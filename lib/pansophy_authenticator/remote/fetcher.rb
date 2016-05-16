require 'pansophy'

module PansophyAuthenticator
  module Remote
    class Fetcher
      include Memoizable

      def keys
        fetch
      end
      memoize :keys

      private

      def fetch
        fail_for_invalid_format! unless parsed_content.is_a? Hash
        parsed_content
      end

      def parsed_content
        YAML.load remote_content
      rescue Psych::SyntaxError
        fail_for_invalid_format!
      end
      memoize :parsed_content

      def remote_content
        Pansophy.read(configuration.bucket_name, configuration.file_path)
      end

      def configuration
        PansophyAuthenticator.valid_configuration
      end

      def fail_for_invalid_format!
        fail Error, 'Remote application keys file is not in a valid format'
      end
    end
  end
end
