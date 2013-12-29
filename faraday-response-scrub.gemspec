# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday/response/scrub/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday-response-scrub"
  spec.version       = Faraday::Response::Scrub::VERSION
  spec.authors       = ["Manbo-"]
  spec.email         = ["Manbo-@server.fake"]
  spec.description   = %q{scrub response body}
  spec.summary       = %q{scrub response body}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "string-scrub"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
end
