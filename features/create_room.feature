Feature: Create a new room to play cards in

  As a user of the service
  So that I can start a new game of cards with my family on the internet
  I want to be able to create a new room

  Background I am on the main page

  Scenario: Navigate to the Create New Room Page
    When I have pressed the create-new-room-button
    Then I should be directed to a new page with a form for creating the new Room

  Scenario: Create New Room
    When I have filled out the room-name-field with the value "Euchre"
    And I have pressed the room-submit-button
    Then The Rooms table in the database should contain this room

  Scenario: Fail to New Room
    When I have filled out the room-name-field with the value ""
    And I have pressed the room-submit-button
    Then I should be redirected-to the main page
    And There should be a warning flash message with content "Room must have a name"