# language: en

Feature: Locations
  In order to be able to navigate the universe
  As a Human Being
  I want to be able to instantiate a room

  Scenario: Add an item to a room
    Given I have a room
    And I added an item to the room
    Then the room should contain an item
