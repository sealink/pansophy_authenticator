module PansophyAuthenticator
  module Configuration
    module Verification
      class Remote
        def initialize(configuration)
          @configuration = configuration
          @result = Result.new
        end

        def verify
          errors = []
          errors << 'Bucket name is not defined' if @configuration.bucket_name.nil?
          errors << 'File path is not defined' if @configuration.file_path.nil?
          Result.new errors
        end
      end
    end
  end
end
