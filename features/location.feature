# language: en
# -*- coding: UTF-8 -*-
# This file is part of SRS GAME <http://github.com/jacksonwillis/srs_game/>.

Feature: Locations
  In order to be able to navigate the universe
  I want to be able to create a map full of locations

  Scenario Outline: Use directions
    Given I have a room
    When I add blank rooms in each direction
    Then the room to <a> of the <b> room is the main room

    Examples:
      | a     | b     |
      | east  | west  |
      | up    | down  |
      | south | north |
      | out   | in    |
      | down  | up    |

  Scenario: Inspect a room's exits
    Given I have a room
    When I add blank rooms in each direction
    Then the room's exits include all directions

  Scenario: Add an item to a room
    Given I have a room
    When I add an item to the room
    Then the room should contain an item
