module PansophyAuthenticator
  module Configuration
    class Configurator
      attr_accessor :local, :bucket_name, :file_path, :configuration_path, :application
      attr_writer :cache_store

      def configuration
        build_configuration
      end

      private

      def build_configuration
        Instance.new(
          local:       config_values.local,
          bucket_name: config_values.bucket_name,
          file_path:   config_values.file_path,
          application: config_values.application
        )
      end

      def config_values
        @config_values ||= from_env
      end

      def base_config
        return self if @configuration_path.nil?
        from_file
      end

      def from_file
        FromFile.new(self)
      end

      def from_env
        FromEnv.new(base_config)
      end
    end
  end
end
