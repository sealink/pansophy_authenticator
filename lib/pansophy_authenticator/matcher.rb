module PansophyAuthenticator
  class Matcher
    def initialize(keys, application)
      @keys        = keys
      @application = application
    end

    def validate!(given_key)
      fail Error, 'Invalid application or key' unless valid?(given_key)
    end

    def valid?(given_key)
      return false unless valid_application?
      given_key == key
    end

    def key
      fail Error, "#{@application} is not defined" unless valid_application?
      @keys.fetch(@application)
    end

    def valid_application?
      @keys.key?(@application)
    end
  end
end
