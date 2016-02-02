module PansophyAuthenticator
  module Local
    class Fetcher
      def keys
        loader.content
      end

      private

      def loader
        @loader ||= BuildLoader.new.call
      end
    end
  end
end
