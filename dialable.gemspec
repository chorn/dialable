# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dialable/version'

Gem::Specification.new do |spec|
  spec.name          = 'dialable'
  spec.version       = Dialable::VERSION
  spec.authors       = ['Chris Horn']
  spec.email         = ['chorn@chorn.com']
  spec.summary       = 'Provides parsing and output of phone numbers according to NANPA standards.'
  spec.description   = 'A gem that provides parsing and output of phone numbers according to NANPA (North American Numbering Plan Administration) standards.  If possible, time zones are populated by abbreviation as well as offset relative to the local timezone.'
  spec.homepage      = 'http://github.com/chorn/dialable'
  spec.licenses      = ['MIT', 'LGPL-2']

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  signing_key = File.expand_path("~/.certs/chorn@chorn.com-rubygems.key")
  if File.file?(signing_key)
    spec.signing_key = signing_key
    spec.cert_chain = ['certs/chorn.pem']
  end

  spec.required_ruby_version = '>= 1.9.0'
  spec.add_runtime_dependency 'tzinfo'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'guard', '~> 2.12'
  spec.add_development_dependency 'guard-bundler', '~> 2.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.3'
end

