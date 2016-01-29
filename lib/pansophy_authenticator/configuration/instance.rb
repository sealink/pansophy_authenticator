require 'anima'

module PansophyAuthenticator
  module Configuration
    class Instance
      include Anima.new(:local, :bucket_name, :file_path, :application)

      def local?
        @local
      end

      def remote?
        !local?
      end
    end
  end
end
