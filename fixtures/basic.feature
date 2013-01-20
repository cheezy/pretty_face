Feature: Basic scenarios
  As a stakeholder
  I want to see some details about this feature
  So that I have some idea why this test matters

  Scenario: A passing scenario
    When Cucumber puts "hello"
    Then it should say hello

  Scenario: A failing scenario
    When the first step fails
    Then the second step should not execute

  Scenario: A pending scenario
    When the first step is pending
    Then the second step is undefined

  Scenario: A undefined scenario
    When all steps are undefined
    Then the scenario is undefined
