# language: en
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Feature: Helpers

  Scenario Outline: Parsing arguments
   Given I have a value <string>
   When I parse the string into arguments
   Then it should return <parsed>

    Examples:
      | string                      | parsed                              |
      | "  3.14 yes gaga false    " | [3.14, true, "gaga", false]         |
      | " true 3 no words         " | [true, 3.0, false, "words"]         |
      | "these words pass tests"    | ["these", "words", "pass", "tests"] |
      | "             HAIL SITHIS " | ["HAIL", "SITHIS"]                  |
      | "         f               " | [false]                             |
      | "\"\" ' ' '              ." | ["\"\"", "'", "'", "'", "."]        |
      | "                         " | []                                  |
