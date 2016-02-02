module PansophyAuthenticator
  module CacheStores
    class Memory
      def initialize
        @hash = {}
      end

      def read(key)
        @hash[key.to_s]
      end

      def write(key, value)
        @hash[key.to_s] = value
      end

      def delete(key)
        @hash.delete(key.to_s)
      end

      def exist?(key)
        @hash.key?(key.to_s)
      end
    end
  end
end
