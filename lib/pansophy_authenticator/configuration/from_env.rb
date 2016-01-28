module PansophyAuthenticator
  module Configuration
    class FromEnv
      def initialize(base_configuration)
        @base_configuration = base_configuration
      end

      def configuration
        Instance.new(
          local:       local,
          bucket_name: bucket_name,
          file_path:   file_path
        )
      end

      private

      def local
        local = ENV.fetch('PANSOPHY_AUTHENTICATOR_LOCAL') { @base_configuration.local? }
        local.to_s == 'true'
      end

      def bucket_name
        ENV.fetch('PANSOPHY_AUTHENTICATOR_BUCKET_NAME') { @base_configuration.bucket_name }
      end

      def file_path
        ENV.fetch('PANSOPHY_AUTHENTICATOR_FILE_PATH') { @base_configuration.file_path }
      end
    end
  end
end
