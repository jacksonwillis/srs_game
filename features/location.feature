# language: en

Feature: Locations
  In order to be able to navigate the universe
  I want to be able to create a map full of locations

  Scenario Outline: Use directions
    Given I have a room
    When I add blank rooms in each direction
    Then the room to <a> of the <b> room is the main room
    And the room's exits include all directions

  Examples:
    | a     | b     |
    | east  | west  |
    | up    | down  |
    | south | north |
    | out   | in    |

  Scenario: Add an item to a room
    Given I have a room
    When I added an item to the room
    Then the room should contain an item
