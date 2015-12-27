require 'yaml'

module Dialable
  module AreaCodes

    def self.datadir
      # If we are in the source directory, don't use the datadir from the gem.
      datadir = if File.identical?(ENV['PWD'], File.join(File.dirname(__FILE__), '..', '..'))
                  File.join(File.dirname(__FILE__), '..', '..', 'data', 'dialable')
                else
                  Gem.datadir('dialable')
                end

      if ! File.directory?(datadir)
        fail "Can't find the datadir provided by the gem: #{Gem.datadir('dialable')} or by the source: #{File.join(File.dirname(__FILE__), '..', 'data', 'dialable')}."
      end

      datadir
    end

    # Valid area codes per nanpa.com
    NANP = YAML.load_file(File.join(datadir, 'nanpa.yaml'))

  end
end
