Feature: pretty girl spike

  Scenario: Cucumber crefates an html report
    When I run `cucumber fixtures --profile fixture`
    Then the following files should exist:
    | fixture.html |

  Scenario: Generating the basic html page from the erb
    When I run `cucumber fixtures --profile fixture`
    Then the file "fixture.html" should contain "DOCTYPE html PUBLIC"
    And the file "fixture.html" should contain "<html"
    And the file "fixture.html" should contain "<head>"
    And the file "fixture.html" should contain "<body>"
    And the file "fixture.html" should contain "<title>Pretty Face Report</title>"

