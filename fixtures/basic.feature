Feature: cucumber spike

  Scenario: Cucumber puts a string
    When Cucumber puts "hello"
    Then it should say hello

  Scenario:  A failing scenario
    When the first step fails
    Then the second step should not execute


