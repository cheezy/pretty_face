require 'fileutils'

When /^I have a logo file in the correct location$/ do
  FileUtils.cp "features/support/logo.png", "features/support/pretty_face/"
end

Then /^I should remove the logo file$/ do
  FileUtils.rm "features/support/pretty_face/logo.png"
end
