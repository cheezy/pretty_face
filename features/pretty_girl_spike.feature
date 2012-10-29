Feature: pretty girl spike
  
  Background:
    When I run `cucumber fixtures --profile fixture`

  Scenario: Cucumber crefates an html report
    Then the following files should exist:
    | fixture.html |

  Scenario: Generating the basic html page from the erb
    Then the file "fixture.html" should contain "DOCTYPE html PUBLIC"
    And the file "fixture.html" should contain "<html"
    And the file "fixture.html" should contain "<head>"
    And the file "fixture.html" should contain "<body>"
    And the file "fixture.html" should contain "<title>Test Results</title>"

  Scenario: Including the styles for the main page
    Then the file "fixture.html" should contain "<style"
    And the file "fixture.html" should contain "</style>"
