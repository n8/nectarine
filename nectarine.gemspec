$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "nectarine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nectarine"
  s.version     = Nectarine::VERSION
  s.authors     = ["n8"]
  s.email       = ["nate.kontny@gmail.com"]
  s.summary     = "Runs a method over a collection of Rails models. But does it in parallel using Active Job."
  s.description = "Runs a method over a collection of Rails models. But does it in parallel using Active Job."
  s.license     = "MIT"
  s.homepage    = "https://github.com/n8/nectarine"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
  s.add_dependency "activejob-status", "~> 0.1.5"

  s.add_development_dependency "sqlite3"
end
