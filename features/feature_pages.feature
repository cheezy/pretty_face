@announce
@focus
Feature: pages that show details for features
  
  Background:
    When I run `cucumber fixtures --profile fixture`

  Scenario: Generate the pages
    Then the following files should exist:
    | results/basic.html    |
    | results/advanced.html |


    
    
