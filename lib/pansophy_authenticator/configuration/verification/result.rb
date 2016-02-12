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

        def +(other_result)
          transform do
            @errors += other_result.errors
          end
        end
      end
    end
  end
end
