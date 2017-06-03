# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'metal_archives/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Florian Dejonckheere']
  gem.email         = ['florian@floriandejonckheere.be']
  gem.summary       = 'Metal Archives Ruby API'
  gem.homepage      = 'http://github.com/floriandejonckheere/metal_archives'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = 'metal_archives'
  gem.require_paths = %w[lib]
  gem.version       = MetalArchives::VERSION
  gem.license       = 'MIT'

  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'faker'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'debase'

  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_throttler'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'countries'
end
