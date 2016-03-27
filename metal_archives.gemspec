require File.expand_path('../lib/metal_archives/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Florian Dejonckheere"]
  gem.email         = ["florian@floriandejonckheere.be"]
  gem.summary       = %q{Metal Archives Web Service wrapper with ActiveRecord-style models}
  gem.homepage      = "http://github.com/floriandejonckheere/metal_archives"

  gem.files         = %x{git ls-files}.split($\)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = "metal_archives"
  gem.require_paths = %w[lib]
  gem.version       = MetalArchives::VERSION
  gem.license       = "MIT"

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'test-unit'

  gem.add_dependency 'faraday'
  gem.add_dependency 'nokogiri'
end
