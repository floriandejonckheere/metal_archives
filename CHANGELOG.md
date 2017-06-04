# Changelog

## 1.0.0

- Add `Artist#photo`
- Return URI instead of String for `Artist#photo`, `Band#logo` and `Band#photo`
- Allow specifying endpoint
- Allow specifying additional Faraday middleware
- Implement `NilDate` class allowing year, month or date to be `nil`
- Add `#cached?` and `#loaded?`
- Add verbose output option
- Return `MetalArchives::Errors::TypeError` in certain cases
- Migrate tests to RSpec

## 0.8.0

- Add configurable endpoint

## 0.7.0

- Add `Band#all` and `Artist#all`

## 0.6.0

- Add LRU object cache
- Remove HTTP cache due to uncacheable response headers
- Add `Band#find_by!` and `Artist#find_by!`

## 0.5.0

- Fix dependency versions

## 0.4.0

- Bubble errors up
- Add `find!`

## 0.3.0

- Add `Collection` iterator

## 0.2.1

- Add correct license
- Lock dependency versions

## 0.2.0

## 0.1.0

Initial release
