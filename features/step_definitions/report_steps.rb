require 'fileutils'

When /^I have a logo file in the correct location$/ do
  FileUtils.cp "features/support/logo.png", "features/support/pretty_face/"
end

Then /^I should remove the logo file$/ do
  FileUtils.rm "features/support/pretty_face/logo.png"
end

When /^I have a suite header partial in the correct location$/ do
  FileUtils.cp "features/support/_suite_header.erb", "features/support/pretty_face"
end

Then /^I should remove the suite header partial file$/ do
  FileUtils.rm "features/support/pretty_face/_suite_header.erb"
end
