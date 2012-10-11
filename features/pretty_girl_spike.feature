Feature: pretty girl spike

Scenario: Cucumber creates an html report
When I run `cucumber fixtures --profile fixture`
Then the file "pretty_report_spike" should contain "hello"
