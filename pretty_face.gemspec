# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pretty_face/version"

Gem::Specification.new do |s|
  s.name        = "pretty_face"
  s.version     = PrettyFace::VERSION
  s.authors     = ["Jeffrey S. Morgan", "Joel Byler"]
  s.email       = ["jeff.morgan@leandog.com", "joelbyler@gmail.com"]
  s.homepage    = "http://github.com/cheezy/pretty_face"
  s.summary     = %q{HTML Report/Formatter  for Cucumber and RSpec}
  s.description = %q{HTML Report/Formatter for cucumber that allows user to modify erb in order to customize.}

  s.rubyforge_project = "pretty_face"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba"

  s.add_runtime_dependency "cucumber"
end
