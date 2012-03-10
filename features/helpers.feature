# language: en
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Feature: Helpers

  Scenario Outline: Blankness
   Given I have a value <value>
   Then its blankness should match <blankness>

  Examples:
    | value        | blankness       |
    | 2            | false           |
    | []           | true            |
    | 1            | false           |
