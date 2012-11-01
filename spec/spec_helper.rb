require 'pretty_face/formatter/html'

Bundler.require(:default, :development)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

include PrettyFace
include PrettyFace::Formatter

RSpec.configure do |config|
end
