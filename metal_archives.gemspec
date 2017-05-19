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

  gem.add_development_dependency 'byebug', '~> 9.0'
  gem.add_development_dependency 'rake', '~> 11.0'
  gem.add_development_dependency 'rdoc', '~> 5.0'
  gem.add_development_dependency 'test-unit', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 3.6'
  gem.add_development_dependency 'factory_girl', '~> 4.8'
  gem.add_development_dependency 'faker', '~> 1.7'
  gem.add_development_dependency 'rubocop', '~> 0.48'

  gem.add_dependency 'faraday', '~> 0.9'
  gem.add_dependency 'faraday_throttler', '~> 0.0.3'
  gem.add_dependency 'nokogiri', '~> 1.6', '>= 1.6.8'
  gem.add_dependency 'countries', '~> 1.2', '>= 1.2.5'
end
