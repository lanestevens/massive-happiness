$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blogr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blogr"
  s.version     = Blogr::VERSION
  s.authors     = ["Andy Leavitt"]
  s.email       = ["andyleavitt@gmail.com"]
  s.homepage    = "http://andyleavitt.com"
  s.summary     = "Summary of Blogr."
  s.description = "Description of Blogr."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency "sqlite3"
end
