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
    Then the file "results/basic.html" should contain "<img src="

  Scenario: It should show start time and duration in the header
    Then the file "results/basic.html" should contain "Feature started:"
    And the file "results/basic.html" should contain "Duration:"

  Scenario: Generating some basic stats from the erb
    Then the file "results/basic.html" should contain "<th>Executed<"
    And the file "results/basic.html" should contain "<th>Average Duration"
    And the file "results/basic.html" should contain "Scenarios"
    And the file "results/basic.html" should contain "Steps"

  Scenario: It should capture scenario and step statuses
    Then the file "results/basic.html" should contain "Passed"
    And the file "results/basic.html" should contain "Failed"
    And the file "results/basic.html" should contain "Pending"
    And the file "results/basic.html" should contain "Undefined"
    And the file "results/basic.html" should contain "Skipped"

  Scenario: It should display scenario names
    Then the file "results/basic.html" should contain "A passing scenario"
    And the file "results/advanced.html" should contain "A scenario outline"
    And the file "results/background.html" should contain "Another passing scenario"

  Scenario: It should display scenario steps
    Then the file "results/basic.html" should contain "it should say hello"
    And the file "results/background.html" should contain "it should say hello"
    And the file "results/advanced.html" should contain "I am using a scenario outline"

  Scenario: It should display the step and data for scenario outline steps
    Then the file "results/advanced.html" should contain "I use aaa"
    And the file "results/advanced.html" should contain "I use bbb"

  Scenario: It should display descriptions for features
    Then the file "results/basic.html" should contain "As a stakeholder"
    Then the file "results/basic.html" should contain "I want to see some details about this feature"
    Then the file "results/basic.html" should contain "So that I have some idea why this test matters"

  Scenario: It should display a nested table
    Then the file "results/advanced.html" should contain "<th>key1</th>"
    And the file "results/advanced.html" should contain "<th>key2</th>"
    And the file "results/advanced.html" should contain "<th>key3</th>"
    And the file "results/advanced.html" should contain "<td>value1</td>"
    And the file "results/advanced.html" should contain "<td>value2</td>"
    And the file "results/advanced.html" should contain "<td>value3</td>"

  Scenario: It should display the multi-line argument
    Then the file "results/advanced.html" should contain "Hello with"
    And the file "results/advanced.html" should contain "more than one"
    And the file "results/advanced.html" should contain "line in a string"

@focus
@announce
  Scenario: It should display errors for features
    Then the file "results/basic.html" should contain "RSpec::Expectations::ExpectationNotMetError"
    And the file "results/advanced.html" should contain "RSpec::Expectations::ExpectationNotMetError"
    And the file "results/failing_background.html" should contain "RSpec::Expectations::ExpectationNotMetError"
    
  Scenario: It should display error message with a yellow background and red text
    Then the file "results/basic.html" should contain "RSpec::Expectations::ExpectationNotMetError"
    And the background of the error message row should be "255, 251, 211"
    And the text of the of the error message row should be "194, 0, 0"

  Scenario: Embedding an image into the page
    Then the file "results/basic.html" should contain "<img id='img_0' style='display: none' src='images/autotrader.png'/>"
    And the file "results/basic.html" should contain "<a href='' onclick="
    And the file "results/basic.html" should contain "img=document.getElementById('img_0'); img.style.display = (img.style.display == 'none' ? 'block' : 'none');return false"
    And the file "results/basic.html" should contain ">AutoTrader</a>"

  Scenario: Displaying a background
    Then the file "results/background.html" should contain "Background: A scenario can have a background"
    And the file "results/background.html" should contain "When  Cucumber puts"

  Scenario: Feature pages should have a link back to the report summary
    Then the file "results/advanced.html" should contain "<a href="

  Scenario: Should create directories when directories exist in features directory
    Then the following files should exist:
    | results/more/more.html |

  Scenario: It should replace the header for the feature pages
    When I have a feature header partial in the correct location
    And I run `cucumber fixtures --profile fixture`
    Then the file "results/basic.html" should contain "The Code Monkeys"
    And the file "results/basic.html" should contain "Test Results"
    And I should remove the feature header partial file
