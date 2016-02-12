module PansophyAuthenticator
  module Configuration
    module Verification
      class Local
        def initialize(configuration)
          @configuration = configuration
        end

        def verify
          return Result.new 'File path is not defined' unless file_path?
          return Result.new "#{file_path} does not exist" unless file_exist?
          Result.new
        end

        private

        def file_path?
          !file_path.nil?
        end

        def file_exist?
          File.exist? file_path
        end

        def file_path
          @configuration.file_path
        end
      end
    end
  end
end
