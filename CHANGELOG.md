# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
This changelog adheres to [Keep a CHANGELOG](http://keepachangelog.com/).

## [Unreleased]
### Changed
- Simplifies verifying validity of configuration
- Use coverage kit to enforce maximum coverage
- [TT-5810] Relax runtime dependencies

## [0.4.3] - 2016-04-07
### Fixed
- Loading of remote YAML application keys file now parses correctly
- Replaces wrong dependency from memoize to memoizable

## [0.4.2] - 2016-04-06
### Fixed
- Updates pansophy gem dependency to version >= 0.5.2

## [0.4.1] - 2016-04-06
### Fixed
- Caches application keys as json to ensure compatibility with third party cache stores
- Updates pansophy gem dependency to version ~> 0.5, >= 0.5.1

## [0.4.0] - 2016-02-16
### Added
- Implements 'application' and 'local?' helper methods

### Fixed
- Tests could be influenced by system environment variables

## [0.3.0] - 2016-02-12
### Added
- Configuration validation

## [0.2.1] - 2016-02-05
### Fixed
- Security fix: be agnostic on cause of validation failure
- Don't raise errors when checking validation via #valid?

## [0.2.0] - 2016-02-02
### Added
- Caching via cache store

## [0.1.0] - 2016-02-01
- Initial release
