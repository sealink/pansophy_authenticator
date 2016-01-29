require 'singleton'

module PansophyAuthenticator
  class ApplicationKeys
    include Singleton

    %i(own key valid? validate!).each do |method|
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

    private

    def matcher(application)
      Matcher.new(retriever.instance.keys, application)
    end

    def retriever
      if PansophyAuthenticator.remote?
        Remote::ApplicationKeys
      else
        Local::ApplicationKeys
      end
    end

    def configuration
      PansophyAuthenticator.configuration
    end
  end
end