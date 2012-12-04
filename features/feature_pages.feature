@focus
Feature: pages that show details for features
  
  Background:
    When I run `cucumber fixtures --profile fixture`

  Scenario: Generate the pages
    Then the following files should exist:
    | results/basic.html    |
    | results/advanced.html |

  Scenario: Generating the basic html page from the erb
    Then the file "results/basic.html" should contain "DOCTYPE html PUBLIC"
    And the file "results/basic.html" should contain "<html xmlns='http://www.w3.org/1999/xhtml'>"
    And the file "results/basic.html" should contain "<head>"
    And the file "results/basic.html" should contain "<body"
    And the file "results/basic.html" should contain "<title>Feature Results</title>"

  Scenario: Including an image / logo
    Then the file "results/fixture.html" should contain "<img src="
    And the file "results/fixture.html" should contain "images/face.jpg"
    
  Scenario: It should show start time and duration in the header
    Then the file "results/fixture.html" should contain "Tests started:"
    And the file "results/fixture.html" should contain "Duration:"
    
