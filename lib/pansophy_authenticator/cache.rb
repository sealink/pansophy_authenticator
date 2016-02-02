# frozen_string_literal: true
module PansophyAuthenticator
  class Cache
    CACHE_KEY = 'pansophy_authenticator_application_keys'.freeze

    def initialize(cache_store)
      @cache_store = cache_store
    end

    def read
      @cache_store.read CACHE_KEY
    end

    def write(value)
      @cache_store.write CACHE_KEY, value
    end

    def delete
      @cache_store.delete CACHE_KEY
    end

    def exist?
      @cache_store.exist? CACHE_KEY
    end

    def fetch
      return read if exist?
      return nil unless block_given?
      yield(CACHE_KEY).tap do |value|
        write(value)
      end
    end
  end
end
