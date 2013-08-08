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
    And the file "results/fixture.html" should contain "<th>Average Duration"
    And the file "results/fixture.html" should contain "Scenarios"
    And the file "results/fixture.html" should contain "Steps"

  Scenario: Including the styles for the main page
    Then the file "results/fixture.html" should contain "<link href='stylesheets/style.css' type='text/css' rel='stylesheet' />"
    And the file "results/fixture.html" should not contain "</style>"
    
  Scenario: Including an image / logo
    Then the file "results/fixture.html" should contain "<img src="

  Scenario: It should copy the style sheet to the stylesheets directory
    Then the following files should exist:
      | results/stylesheets/style.css |

  Scenario: It should copy the logo image to the images directory
    Then the following files should exist:
    | results/images/face.jpg |

  Scenario: It should show start time and duration in the header
    Then the file "results/fixture.html" should contain "started:"
    And the file "results/fixture.html" should contain "duration:"

  Scenario: It should capture scenario and step statuses
    Then the file "results/fixture.html" should contain "Passed"
    And the file "results/fixture.html" should contain "Failed"
    And the file "results/fixture.html" should contain "Pending"
    And the file "results/fixture.html" should contain "Undefined"
    And the file "results/fixture.html" should contain "Skipped"

  Scenario: It should display all of the tests with failures
    Then the file "results/fixture.html" should contain "Tests With Failures:"

  Scenario: It should display a list of all features / scenarios
    Then the file "results/fixture.html" should contain "Feature Overview:"

  Scenario: It should display useful information about each scenario
    Then the file "results/fixture.html" should contain "Feature"
    And the file "results/fixture.html" should contain "File"
    And the file "results/fixture.html" should contain "Passed"
    And the file "results/fixture.html" should contain "Failed"
    And the file "results/fixture.html" should contain "Pending"
    And the file "results/fixture.html" should contain "Undefined"
    And the file "results/fixture.html" should contain "Skipped"

  Scenario: It should display the data from scenario outlines
    Then the file "results/fixture.html" should contain "| aaa | bbb |"
    And the file "results/fixture.html" should contain "| ccc | ddd |"
  
  Scenario: It should replace the logo image on the top level page
    When I have a logo file in the correct location
    And I run `cucumber fixtures --profile fixture`
    Then the file "results/fixture.html" should contain "img src='images/logo.png'"
    And I should remove the logo file

  Scenario: It should replace the header for the main page of the report
    When I have a suite header partial in the correct location
    And I run `cucumber fixtures --profile fixture`
    Then the file "results/fixture.html" should contain "The Code Monkeys"
    And the file "results/fixture.html" should contain "Test Results"
    And I should remove the suite header partial file

