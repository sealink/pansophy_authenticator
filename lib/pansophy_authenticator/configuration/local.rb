module PansophyAuthenticator
  module Configuration
    class Local < Base
      def errors
        errors = super
        return errors + ['File path is not defined'] unless file_path?
        return errors + ["#{@file_path} does not exist"] unless file_exist?
        errors
      end

      def local?
        true
      end

      private

      def file_path?
        !@file_path.nil?
      end

      def file_exist?
        File.exist? @file_path
      end
    end
  end
end
