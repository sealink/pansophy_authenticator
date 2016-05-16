module PansophyAuthenticator
  module Configuration
    class Remote < Base
      def verification
        Result.new errors
      end

      def errors
        errors = super
        errors << 'Bucket name is not defined' if @bucket_name.nil?
        errors << 'File path is not defined' if @file_path.nil?
        errors
      end
    end
  end
end
