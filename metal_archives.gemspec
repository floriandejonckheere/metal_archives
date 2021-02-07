# frozen_string_literal: true

require_relative "lib/metal_archives/version"

Gem::Specification.new do |spec|
  spec.name          = "metal_archives"
  spec.version       = MetalArchives::VERSION
  spec.authors       = ["Florian Dejonckheere"]
  spec.email         = ["florian@floriandejonckheere.be"]

  spec.summary       = "Metal Archives Ruby API"
  spec.description   = "Ruby API layer that transparently queries, scrapes and caches Metal Archives' website"
  spec.homepage      = "https://github.com/floriandejonckheere/metal_archives"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.8")

  spec.metadata["source_code_uri"] = "https://github.com/floriandejonckheere/metal_archives"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r(^bin/)) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "countries"
  spec.add_runtime_dependency "http"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "zeitwerk"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "debase"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "fasterer"
  spec.add_development_dependency "ffaker"
  spec.add_development_dependency "flay"
  spec.add_development_dependency "overcommit"
  spec.add_development_dependency "pronto"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "reek"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "webmock"
end
