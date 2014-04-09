$LOAD_PATH.push File.join(File.dirname(__FILE__), '..', 'lib')

require "rubygems"
require "dialable"
require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
end
