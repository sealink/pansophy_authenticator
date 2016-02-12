module PansophyAuthenticator
  module Configuration
    module Verification
      class Verify
        def initialize(configuration)
          @configuration = configuration
        end

        def call
          verifiers.map { |verifier| verifier.new(@configuration).verify }.reduce(&:+)
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
