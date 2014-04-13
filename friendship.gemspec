$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "friendship/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "friendship"
  s.version     = Friendship::VERSION
  s.authors     = ["ponpocopocopoco"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = ""
  s.description = "Friend relations are given to a user table."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  #s.add_dependency "rails", "~> 4.0.0"

  #s.add_development_dependency "sqlite3"
end
