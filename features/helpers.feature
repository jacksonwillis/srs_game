# language: en

Feature: Helpers

  Scenario Outline: Blankness
   Given I have a value <value>
   Then its blankness should match <blankness>

  Examples:
    | value        | blankness       |
    | 2            | false           |
    | []           | true            |
    | 1            | false           |
