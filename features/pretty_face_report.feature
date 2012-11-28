Feature: pretty face report
  
  Background:
    When I run `cucumber fixtures --profile fixture`

  Scenario: Cucumber crefates an html report
    Then the following files should exist:
    | results/fixture.html |

  Scenario: Generating the basic html page from the erb
    Then the file "results/fixture.html" should contain "DOCTYPE html PUBLIC"
    And the file "results/fixture.html" should contain "<html xmlns='http://www.w3.org/1999/xhtml'>"
    And the file "results/fixture.html" should contain "<head>"
    And the file "results/fixture.html" should contain "<body"
    And the file "results/fixture.html" should contain "<title>Test Results</title>"

  Scenario: Generating some basic stats from the erb
    Then the file "results/fixture.html" should contain "<th>Executed<"
    And the file "results/fixture.html" should contain "<th>Average<br/>Duration"
    And the file "results/fixture.html" should contain "Scenarios"
    And the file "results/fixture.html" should contain "Steps"

  Scenario: Including the styles for the main page
    Then the file "results/fixture.html" should contain "<style type='text/css'>"
    And the file "results/fixture.html" should contain "</style>"
    
  Scenario: Including an image / logo
    Then the file "results/fixture.html" should contain "<img src="
    And the file "results/fixture.html" should contain "images/face.jpg"

  Scenario: It should copy the logo image to the images directory
    Then the following files should exist:
    | results/images/face.jpg |

  Scenario: It should show start time and duration in the header
    Then the file "results/fixture.html" should contain "Tests started:"
    And the file "results/fixture.html" should contain "Duration:"

  Scenario: It should capture scenario and step statuses
    Then the file "results/fixture.html" should contain "Passed"
    And the file "results/fixture.html" should contain "Failed"
    And the file "results/fixture.html" should contain "Pending"
    And the file "results/fixture.html" should contain "Undefined"
    And the file "results/fixture.html" should contain "Skipped"

  Scenario: It should display all of the tests with failures
    Then the file "results/fixture.html" should contain "Tests With Failures:"

  Scenario: It should display a list of all features / scenarios
    Then the file "results/fixture.html" should contain "Scenario Overview:"

  Scenario: It should display useful information about each scenario
    Then the file "results/fixture.html" should contain "Result"
    And the file "results/fixture.html" should contain "Name"
    And the file "results/fixture.html" should contain "# Steps"
    And the file "results/fixture.html" should contain "Duration"

  Scenario: It should display the data from scenario outlines
    Then the file "results/fixture.html" should contain "| aaa | bbb |"
    And the file "results/fixture.html" should contain "| ccc | ddd |"
  
  Scenario: It should display the scenario name for scenario outlines
    Then the file "results/fixture.html" should contain "A scenario outline"
