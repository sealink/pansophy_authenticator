# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pansophy_authenticator/version'

Gem::Specification.new do |spec|
  spec.name          = 'pansophy_authenticator'
  spec.version       = PansophyAuthenticator::VERSION
  spec.authors       = ['Alessandro Berardi']
  spec.email         = ['berardialessandro@gmail.com']

  spec.summary       = 'Inter application authentication via central authority'
  spec.description   = 'By configuring a set of applications authentication keys in a file'\
                       'stored in an S3 bucket, applications can authenticate with each other'\
                       'by submitting their authentication key, which the receiver can match'\
                       'against the key stored in S3.'\
                       'S3 becomes then a central authentication authority.'
  spec.homepage      = 'https://github.com/sealink/pansophy_authenticator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
                                        .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'memoize', '~> 1.3'
  spec.add_dependency 'anima', '~> 0.3'
  spec.add_dependency 'adamantium', '~> 0.2'
  spec.add_dependency 'pansophy', '~> 0.5', '>= 0.5.1'
  spec.add_dependency 'yamload', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'timecop', '~> 0.8'
  spec.add_development_dependency 'simplecov', '~> 0.11'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'rubocop', '~> 0.39'
  spec.add_development_dependency 'travis', '~> 1.8'
end
