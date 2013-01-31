Feature: Background for scenarios

  Background: A scenario can have a background
    When Cucumber puts "hello" in a background

  Scenario: A passing scenario
    Then it should say hello

  Scenario: Another passing scenario
    Then it should say hello
