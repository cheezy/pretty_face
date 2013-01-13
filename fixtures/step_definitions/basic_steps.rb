When /^Cucumber puts "(.*?)"$/ do |some_string|
  puts some_string
  sleep 1
end

Then /^it should say hello$/ do
  puts "It said hello"
end

When /^the first step fails$/ do
 true.should == false
end

Then /^the second step should not execute$/ do
  puts "Should not execute"
end

When /^the first step is pending$/ do
  pending
end
