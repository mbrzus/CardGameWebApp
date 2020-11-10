Feature: Create a new room to play cards in

  As a user of the service
  So that I can start a new game of cards with my family on the internet
  I want to be able to create a new room

  Scenario: Directed to New Room Form
    Given I am on the main page
    When I have pressed new_room_button
    Then I should be at the new room form

  Scenario: Create New Room
    Given I am on the main page
    When I have pressed new_room_button
    And  I have pressed create_room_submit
    Then a room should be created in the database

  Scenario: Automatically Enter the Created Room
    Given I am on the main page
    When I have pressed new_room_button
    And  I have pressed create_room_submit
    Then I should be in the newly created room