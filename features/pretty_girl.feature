Feature: pretty girl spike
  
  Background:
    When I run `cucumber fixtures --profile fixture`

  Scenario: Cucumber crefates an html report
    Then the following files should exist:
    | fixture.html |

  Scenario: Generating the basic html page from the erb
    Then the file "fixture.html" should contain "DOCTYPE html PUBLIC"
    And the file "fixture.html" should contain "<html xmlns='http://www.w3.org/1999/xhtml'>"
    And the file "fixture.html" should contain "<head>"
    And the file "fixture.html" should contain "<body>"
    And the file "fixture.html" should contain "<title>Test Results</title>"

  Scenario: Generating some basic stats from the erb
    Then the file "fixture.html" should contain "<th>Executed<"
    And the file "fixture.html" should contain "<th>Average<br"
    And the file "fixture.html" should contain "<td>1<"
    And the file "fixture.html" should contain "<td>0."

  Scenario: Including the styles for the main page
    Then the file "fixture.html" should contain "<style type='text/css'>"
    And the file "fixture.html" should contain "</style>"
    
  Scenario: Including an image / logo
    Then the file "fixture.html" should contain "<img src="
    And the file "fixture.html" should contain "images/face.jpg"

  Scenario: It should copy the logo image to the images directory
    Then the following files should exist:
    | images/face.jpg |


