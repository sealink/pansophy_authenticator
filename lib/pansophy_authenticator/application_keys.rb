require 'singleton'

module PansophyAuthenticator
  class ApplicationKeys
    include Singleton

    %i(own key valid? validate! clear_cache).each do |method|
      define_singleton_method(method) { |*args| instance.send(method, *args) }
    end

    def own
      key(configuration.application)
    end

    def key(application)
      matcher(application).key
    end

    def valid?(application, key)
      matcher(application).valid?(key)
    end

    def validate!(application, key)
      matcher(application).validate!(key)
    end

    def clear_cache
      cache.delete
    end

    private

    def matcher(application)
      Matcher.new(keys, application)
    end

    def keys
      cache.fetch { fetcher.keys }
    end

    def cache
      Cache.new(configuration.cache_store)
    end

    def fetcher
      if PansophyAuthenticator.remote?
        Remote::Fetcher.new
      else
        Local::Fetcher.new
      end
    end

    def configuration
      PansophyAuthenticator.configuration
    end
  end
end
