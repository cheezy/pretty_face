Feature: Failing Background for scenarios

  Background: A scenario can have a failing background
    Given the first step fails

  Scenario: A scenario with failing background
    Then the second step should not execute