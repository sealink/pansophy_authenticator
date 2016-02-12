module PansophyAuthenticator
  module Configuration
    module Verification
      class Common
        def initialize(configuration)
          @configuration = configuration
        end

        def verify
          return Result.new 'Application is not defined' if @configuration.application.nil?
          Result.new
        end
      end
    end
  end
end
