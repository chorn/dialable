Gem::Specification.new do |s|
  s.licenses = ['MIT', 'LGPL-2']
  s.name     = "dialable"
  s.version  = "0.5.0"
  s.date     = "2011-06-22"
  s.summary  = "Provides parsing and output of phone numbers according to NANPA standards."
  s.email    = "chorn@chorn.com"
  s.homepage = "http://github.com/chorn/dialable"
  s.description = "A gem that provides parsing and output of phone numbers according to NANPA (North American Numbering Plan Administration) standards.  If possible, time zones are populated by abbreviation as well as offset relative to the local timezone."
  s.has_rdoc = true
  s.authors  = ["Chris Horn"]
  s.files    = [ "LICENSE",
                 "README.rdoc",
                 "Rakefile",
                 "TODO",
                 "dialable.gemspec",
                 "lib/dialable.rb",
                 "data/nanpa.yaml",
                 "spec/dialable_spec.rb",
                 "spec/spec_helper.rb",
                 "support/make_yaml_nanpa.rb"
                 ]
  s.test_files = []
  s.rdoc_options = []
end
