$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "valid_url/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "valid_url"
  s.version     = ValidUrl::VERSION
  s.authors     = ["Roman Ralovets"]
  s.email       = ["roman@ralovets.ru"]
  s.homepage    = "https://github.com/ralovets/valid_url"
  s.summary     = "The most accurate and reliable rails url validator"
  s.description = "Provides with the ability to validate url (Rails 4)"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency 'rspec'

  s.add_dependency "rails"
  s.add_dependency "addressable"
end
