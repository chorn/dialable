require 'rubygems'
require 'rubygems/specification'
require 'date'
require 'rspec/core/rake_task'

GEM = "dialable"
GEM_VERSION = "0.5.0"
AUTHOR = "Chris Horn"
EMAIL = "chorn@chorn.com"
HOMEPAGE = "http://github.com/chorn/dialable"
SUMMARY = "A gem that provides parsing and output of phone numbers according to NANPA standards."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec,support,data}/**/*")
end

task :default => :spec

RSpec::Core::RakeTask.new(:spec)

desc "install the gem locally"
task :install => [:package] do
  sh %{gem install pkg/#{GEM}-#{GEM_VERSION}}
end

