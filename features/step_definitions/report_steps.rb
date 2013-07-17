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

When /^I have a feature header partial in the correct location$/ do
  FileUtils.cp "features/support/_feature_header.erb", "features/support/pretty_face"
end

Then /^I should remove the feature header partial file$/ do
  FileUtils.rm "features/support/pretty_face/_feature_header.erb"
end

Then(/^the background of the error message row should be "(.*?)"$/) do |background|
  @browser = Watir::Browser.new :firefox
  visit ErrorDisplay do |page|
    page.error_background.should include background
  end
end

Then(/^the text of the of the error message row should be "(.*?)"$/) do |color|
  on(ErrorDisplay).error_text_color.should include color
end
