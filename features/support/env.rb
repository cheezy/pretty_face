$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'aruba/cucumber'
require 'page-object'
require 'pretty_face'
require 'watir-webdriver'

World PageObject::PageFactory

Before do
  @dirs = [File.join(File.dirname(__FILE__), '..', '..')]
end

After do
  @browser.close if @browser
end
