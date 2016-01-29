module PansophyAuthenticator
  class Matcher
    def initialize(keys, application)
      @keys        = keys
      @application = application
    end

    def validate!(given_key)
      fail Error, "Invalid key for #{@application}" unless valid?(given_key)
    end

    def valid?(given_key)
      given_key == key
    end

    def key
      fail Error, "#{@application} is not defined" unless @keys.key?(@application)
      @keys.fetch(@application)
    end
  end
end
