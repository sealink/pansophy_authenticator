module PansophyAuthenticator
  module Configuration
    class Configurator
      attr_accessor :local, :bucket_name, :file_path, :configuration_path, :application

      def configuration
        from_env
      end

      private

      def base_config
        return self if @configuration_path.nil?
        from_file
      end

      def from_file
        FromFile.new(self).configuration
      end

      def from_env
        FromEnv.new(base_config).configuration
      end
    end
  end
end
