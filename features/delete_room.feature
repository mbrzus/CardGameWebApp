Feature: Delete an existing room
  As a room administrator
  So that I can remove old rooms and create new ones
  I want to be able to delete an existing room

  Scenario: Delete an existing room
    Given I am on Room "1"
    When I have pressed end_game
    Then I should be on the main page with the notice "Game ended successfully. Thank you for playing!."