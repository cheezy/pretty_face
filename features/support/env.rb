$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'aruba/cucumber'

require 'pretty_face'

Before do
  @dirs = [File.join(File.dirname(__FILE__), '..', '..')]
end
