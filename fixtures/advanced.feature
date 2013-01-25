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

  Scenario: Nested table in a step
    When I have a nested table step like this:
    | key1   | key2   | key3   |
    | value1 | value2 | value3 |
    Then the table should be displayed in the results

  Scenario: A scenario with muti-line arguments
    When Cucumber puts
      """
      Hello with
      more than one
      line in a string
      """
    Then it should say
      """
      Hello with
      more than one
      line in a string
      """
