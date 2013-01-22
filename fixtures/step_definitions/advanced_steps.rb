Given /^I am using a scenario outline$/ do
  
end

When /^I use (.*?)$/ do |value|

end

When /^I fail with (.*?)$/ do |value|
  true.should == false
end


Then /^the examples should(?: not)? work$/ do
  sleep 1
end

