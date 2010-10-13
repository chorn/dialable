$LOAD_PATH.push File.join(File.dirname(__FILE__), '..', 'lib')

require "rubygems"
require "spec"
require "active_support"
require "dialable"

Spec::Runner.configure do |config|
  # config.mock_with :mocha
end
