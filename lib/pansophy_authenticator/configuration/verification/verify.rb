module PansophyAuthenticator
  module Configuration
    module Verification
      class Verify
        def initialize(configuration)
          @configuration = configuration
        end

        def call
          verifiers = [Common]
          if @configuration.local?
            verifiers << Local
          else
            verifiers << Remote
          end
          verifiers.inject(Result.new) { |result, verifier|
            result.concat verifier.new(@configuration).verify
          }
        end
      end
    end
  end
end
