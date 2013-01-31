# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dialable/version'

spec = Gem::Specification.new do |gem|
  gem.licenses      = ['MIT', 'LGPL-2']
  gem.required_ruby_version = '>= 1.9.0'
  gem.name          = "dialable"
  gem.version       = Dialable::VERSION
  gem.authors       = ["chorn"]
  gem.email         = ["chorn@chorn.com"]
  gem.description   = %q{A gem that provides parsing and output of phone numbers according to NANPA (North American Numbering Plan Administration) standards.  If possible, time zones are populated by abbreviation as well as offset relative to the local timezone.}
  gem.summary       = %q{Provides parsing and output of phone numbers according to NANPA standards.}
  gem.homepage      = "http://github.com/chorn/dialable"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "tzinfo"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "tzinfo"
  gem.add_development_dependency "timecop"
end

