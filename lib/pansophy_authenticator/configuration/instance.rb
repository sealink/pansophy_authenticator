require 'anima'
require 'memoizable'

module PansophyAuthenticator
  module Configuration
    class Instance
      include Anima.new :local, :bucket_name, :file_path, :application, :cache_store
      include Memoizable

      def local?
        @local
      end

      def remote?
        !local?
      end

      def valid?
        verification.valid?
      end

      def errors
        verification.errors
      end

      private

      def verification
        Verification::Verify.new(self).call
      end
      memoize :verification
    end
  end
end
