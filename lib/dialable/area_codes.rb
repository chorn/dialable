require 'yaml'

module Dialable
  module AreaCodes

    # Valid area codes per nanpa.com
    data_path = Gem.datadir('dialable')
    data_path ||= File.join(File.dirname(__FILE__), '..', 'data', 'dialable')

    NANP = YAML.load_file(File.join(data_path, 'nanpa.yaml'))

  end
end
