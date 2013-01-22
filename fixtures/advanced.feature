Feature: Advanced scenarios

  Scenario Outline: A scenario outline
    Given I am using a scenario outline
    When I use <first>
    And I use <second>
    Then the examples should work

  Examples:
  | first | second |
  | aaa   | bbb    |
  | ccc   | ddd    |
  | eee   | fff    |
    
  Scenario Outline:  Fails during examples
    Given I am using a scenario outline
    When I fail with <first>
    Then I use <second>
    Then the examples should not work
  
  Examples:
  | first | second |
  | aaa   | bbb    |
  | ccc   | ddd    |
  | eee   | fff    |
  
  Scenario Outline:  Fails before examples
    Given the first step fails
    When I use <first>
    And I use <second>
    Then the examples should not work

  Examples:
  | first | second |
  | aaa   | bbb    |
  | ccc   | ddd    |
  | eee   | fff    |
  
  

