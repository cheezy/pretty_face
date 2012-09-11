Feature: pretty girl spike

Scenario: Cucumber runs
When I run `cucumber fixtures --profile fixture`
Then the output should contain "hello"
