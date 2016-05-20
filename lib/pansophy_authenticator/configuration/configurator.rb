module PansophyAuthenticator
  module Configuration
    class Configurator
      attr_accessor :local, :bucket_name, :file_path, :configuration_path, :application
      attr_writer :cache_store

      def configuration
        build_configuration
      end

      def cache_store
        @cache_store ||= CacheStores::Memory.new
      end

      private

      def build_configuration
        attrs = {
          bucket_name: config_values.bucket_name,
          file_path:   config_values.file_path,
          application: config_values.application,
          cache_store: cache_store
        }
        if config_values.local
          Local.new(attrs)
        else
          Remote.new(attrs)
        end
      end

      def config_values
        @config_values ||= from_env_or_base
      end

      def from_env_or_base
        FromEnv.new(base_config)
      end

      def base_config
        return self if @configuration_path.nil?
        from_file_or_base
      end

      def from_file_or_base
        FromFile.new(self)
      end
    end
  end
end
