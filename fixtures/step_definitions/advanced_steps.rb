Given /^I am using a scenario outline$/ do

end

When /^I use (.*?)$/ do |value|

end

Then /^the examples should work$/ do
  sleep 1
end

When /^I have a nested table step like this:$/ do |table|

end

Then /^the table should be displayed in the results$/ do

end

When /^Cucumber puts$/ do |some_string|
  puts some_string
  @last_string = some_string
  sleep 1
end

Then /^it should say$/ do |some_string|
  @last_string.should == some_string
end
