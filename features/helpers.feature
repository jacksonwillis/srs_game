# language: en
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Feature: Helpers

  Scenario Outline: Parsing a string into arguments
    Given I have a value <string>
    When I parse the string into arguments
    Then it should return <parsed>

    Examples:
      | string                   | parsed                              |
      | "  3.14 yes gaga false " | [3.14, true, "gaga", false]         |
      | " true 3 no words      " | [true, 3.0, false, "words"]         |
      | "these words pass tests" | ["these", "words", "pass", "tests"] |
      | "          HAIL SITHIS " | ["HAIL", "SITHIS"]                  |
      | "         f            " | [false]                             |
      | "\"\" ' ' '         ."   | ["\"\"", "'", "'", "'", "."]        |
      | "                      " | []                                  |

  Scenario Outline: Parsing a string into a boolean
    Given I have a string <string>
    When I parse the string into a boolean
    Then it should return <parsed>

    Examples:
      | string | parsed |
      | true   | true   |
      | yes    | true   |
      | n      | false  |
      | t      | true   |
      | no     | false  |
      | false  | false  |
      | f      | false  |
      | TRUE   | true   |
      | FALSE  | false  |
      | Y      | true   |
      | No     | false  |
      | T      | true   |
      | faLse  | false  |
      | word   | nil    |
      | yes no | nil    |
