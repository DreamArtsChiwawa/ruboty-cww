
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruboty/cww/version"

Gem::Specification.new do |spec|
  spec.name          = "ruboty-cww"
  spec.version       = Ruboty::Cww::VERSION
  spec.authors       = ["DreamArts Corporation."]
  spec.license       = "DreamArts All Rights Reserved."

  spec.summary       = %q{Chiwawa adapter for Ruboty.}
  spec.homepage      = "https://github.com/DreamArtsChiwawa/ruboty-cww"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.0"
  spec.add_dependency "ruboty", ">= 1.0.4"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
