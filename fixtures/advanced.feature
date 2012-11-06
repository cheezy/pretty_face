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

