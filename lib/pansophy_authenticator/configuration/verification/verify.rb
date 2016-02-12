module PansophyAuthenticator
  module Configuration
    module Verification
      class Verify
        def initialize(configuration)
          @configuration = configuration
        end

        def call
          verifiers.inject(Result.new) { |result, verifier|
            result.concat verifier.new(@configuration).verify
          }
        end

        private

        def verifiers
          [Common, specific_verifier]
        end

        def specific_verifier
          if @configuration.local?
            Local
          else
            Remote
          end
        end
      end
    end
  end
end
