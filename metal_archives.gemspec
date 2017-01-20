require File.expand_path('../lib/metal_archives/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Florian Dejonckheere"]
  gem.email         = ["florian@floriandejonckheere.be"]
  gem.summary       = %q{Metal Archives Ruby API}
  gem.homepage      = "http://github.com/floriandejonckheere/metal_archives"

  gem.files         = %x{git ls-files}.split($\)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = "metal_archives"
  gem.require_paths = %w[lib]
  gem.version       = MetalArchives::VERSION
  gem.license       = "MIT"

  gem.add_development_dependency 'byebug', '~> 9.0'
  gem.add_development_dependency 'rake', '~> 11.0'
  gem.add_development_dependency 'rdoc', '~> 5.0'
  gem.add_development_dependency 'test-unit', '~> 3.0'
  gem.add_development_dependency 'activesupport', '~> 5.0'

  gem.add_dependency 'faraday', '~> 0.9'
  gem.add_dependency 'faraday_throttler', '~> 0.0.3'
  gem.add_dependency 'nokogiri', '~> 1.6.8'
  gem.add_dependency 'countries', '~> 1.2.5'
end
