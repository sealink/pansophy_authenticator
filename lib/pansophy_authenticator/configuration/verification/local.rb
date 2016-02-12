module PansophyAuthenticator
  module Configuration
    module Verification
      class Local
        def initialize(configuration)
          @configuration = configuration
        end

        def verify
          Result.new errors
        end

        private

        def errors
          return ['File path is not defined'] unless file_path?
          return ["#{file_path} does not exist"] unless file_exist?
          []
        end

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
