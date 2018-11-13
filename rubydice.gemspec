
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubydice/version"

Gem::Specification.new do |spec|
  spec.name          = "rubydice"
  spec.version       = Rubydice::VERSION
  spec.authors       = ["Aaron Tavistock"]
  spec.email         = ["aaron@geekshow.com"]

  spec.summary       = %q{Simple RPG dice library}
  spec.description   = %q{Support for most common tabletop RPG dice configurations}
  spec.homepage      = "http://github.com/atavistock/rubydice"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.0"
end
