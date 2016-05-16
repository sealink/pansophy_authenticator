require 'anima'
require 'memoizable'

module PansophyAuthenticator
  module Configuration
    class Base
      include Anima.new :bucket_name, :file_path, :application, :cache_store
      include Memoizable

      def local?
        is_a?(Local)
      end

      def remote?
        !local?
      end

      def errors
        return ['Application is not defined'] if @application.nil?
        []
      end

      def valid?
        verification.valid?
      end
    end
  end
end
