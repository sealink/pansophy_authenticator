module PansophyAuthenticator
  module Configuration
    class Remote < Base
      def errors
        errors = super
        return errors + ['Bucket name is not defined'] if @bucket_name.nil?
        return errors + ['File path is not defined'] if @file_path.nil?
        errors
      end
    end
  end
end
