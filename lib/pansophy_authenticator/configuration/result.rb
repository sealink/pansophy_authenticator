module PansophyAuthenticator
  module Configuration
    class Result
      include Adamantium

      attr_reader :errors

      def initialize(errors = [])
        @errors = Array(errors)
      end

      def valid?
        @errors.empty?
      end
    end
  end
end
