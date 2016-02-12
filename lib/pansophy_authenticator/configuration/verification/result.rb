module PansophyAuthenticator
  module Configuration
    module Verification
      class Result
        include Adamantium

        attr_reader :errors

        def initialize(errors = [])
          @errors = Array(errors)
        end

        def valid?
          @errors.empty?
        end

        def +(other)
          transform do
            @errors += other.errors
          end
        end
      end
    end
  end
end
