Feature: basic scenarios

  Scenario: A passing scenario
    When Cucumber puts "hello"
    Then it should say hello

  Scenario: A failing scenario
    When the first step fails
    Then the second step should not execute

  Scenario: A pending scenario
    When the first step is pending
    Then the second step is undefined
