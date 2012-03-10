# language: en

Feature: Locations
  In order to be able to navigate the universe
  I want to be able to create a map full of locations

  Scenario: Use directions
    Given I have an example room with blank rooms in each direction
    Then the room to west of east room is the main room
    And the room's exits include all directions

  Scenario: Add an item to a room
    Given I have a room
    And I added an item to the room
    Then the room should contain an item
