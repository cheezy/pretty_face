Feature: pretty girl spike

  Scenario: Cucumber crefates an html report
    When I run `cucumber fixtures --profile fixture`
    Then the following files should exist:
    | fixture.html |
