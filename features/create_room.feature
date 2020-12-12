Feature: Create a new room to play cards in

  As a user of the service
  So that I can start a new game of cards with my family on the internet
  I want to be able to create a new room

  Given The following rooms have been added to the database
  | id| player_limit| room_token|
  |  5|           10|       AZKR|
  |  6|           10|       AZKL|
  |  7|           10|       AZKP|



  Scenario: Directed to New Room Form
    Given I am signed in
    And I am on the main page
    When I have pressed new_room_button
    Then I should be at the new room form

  Scenario: Create New Room
    Given I am signed in
    And I am on the main page
    When I have pressed new_room_button
    And  I have pressed create_room_submit
    Then A room should be created in the database

  Scenario: Automatically Enter the Created Room
    Given I am signed in
    And I am on the main page
    When I have pressed new_room_button
    And  I have pressed create_room_submit
    Then I should be directed to the create_player page