## [Unreleased]
### Fixed
- Caches application keys as json to ensure compatibility with third party cache stores

### Changed
- Updates pansophy gem dependency to version ~> 0.5, >= 0.5.1

## 0.4.0 (2016-02-16)
### Added
- Implements 'application' and 'local?' helper methods
  
### Fixed
- Tests could be influenced by system environment variables

## 0.3.0 (2016-02-12)
### Added
- Configuration validation

## 0.2.1 (2016-02-05)
### Fixed
- Security fix: be agnostic on cause of validation failure
- Don't raise errors when checking validation via #valid?

## 0.2.0 (2016-02-02)
### Added
- Caching via cache store

## 0.1.0 (2016-02-01)
- Initial release
