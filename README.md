# PansophyAuthenticator

[![Gem Version](https://badge.fury.io/rb/pansophy_authenticator.svg)](http://badge.fury.io/rb/pansophy_authenticator)
[![Build Status](https://travis-ci.org/sealink/pansophy_authenticator.svg?branch=master)](https://travis-ci.org/sealink/pansophy_authenticator)
[![Coverage Status](https://coveralls.io/repos/sealink/pansophy_authenticator/badge.svg)](https://coveralls.io/r/sealink/pansophy_authenticator)
[![Dependency Status](https://gemnasium.com/sealink/pansophy_authenticator.svg)](https://gemnasium.com/sealink/pansophy_authenticator)
[![Code Climate](https://codeclimate.com/github/sealink/pansophy_authenticator/badges/gpa.svg)](https://codeclimate.com/github/sealink/pansophy_authenticator)

Centralised application authentication via S3

By configuring a set of applications authentication keys in a file stored in an S3 bucket, 
applications can authenticate with each other by submitting their authentication key, 
which the receiver can match against the key stored in S3.
S3 becomes then a central authentication authority.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pansophy_authenticator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pansophy_authenticator

## Usage

### Configuration

PansophyAuthenticator has three levels of configuration:

* Via environment variables
    
    ```bash
    PANSOPHY_AUTHENTICATOR_LOCAL=false
    PANSOPHY_AUTHENTICATOR_BUCKET_NAME=my_bucket
    PANSOPHY_AUTHENTICATOR_FILE_PATH=config/app_keys.yml
    ```
    
* Via a configuration file

    ```ruby
    PansophyAuthenticator.configure do |configuration|
      basedir = Pathname.new(__FILE__).expand_path.dirname.parent
      configuration.configuration_path = basedir.join('config').join('authenticator.yml')
    end
    ```
    Note: If the file name is omitted, it will default to ``pansophy_authenticator.yml``

    ``authenticator.yml`` :
    ```yaml
    ---
    bucket_name: 'my_bucket'
    file_path: 'config/app_keys.yml'
    ```
    
* Via the configurator
    
    ```ruby
    PansophyAuthenticator.configure do |configuration|
      configuration.local       = false
      configuration.bucket_name = 'my_bucket'
      configuration.file_path   = 'config/app_keys.yml'
    end
    ```

Each level has precedence on the next, i.e. environment variables will have precedence over file based configuration, which, in turn, will have precedence over the configurator

The configuration options are:

* *local* true if the location of the application keys file is on the local host
* *bucket_name* the name of the bucket in S3 where the application keys file is kept
* *file_path* the remote or local path to the application keys file

When working in remote mode (``local = false``), AWS access environment variables must be set, e.g.:
    
```bash
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_REGION=ap-southeast-2
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pansophy_authenticator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

