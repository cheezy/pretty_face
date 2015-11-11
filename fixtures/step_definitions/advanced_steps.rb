Given /^I am using a scenario outline$/ do

end

When /^I use (.*?)$/ do |value|

end

When /^I fail with (.*?)$/ do |value|
  expect(true).to be false
end


Then /^the examples should(?: not)? work$/ do
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
  expect(@last_string).to eql some_string
end
