Feature: Join an existing room to play cards in

  As a user of the service
  So that I can play a card game with a small group of people
  I want to be able to join am existing room

  Given The following rooms have been added to the database
  | id| player_limit| room_token|
  |  5|           10|       AZKR|
  |  6|           10|       AZKL|
  |  7|           10|       AZKP|

  And I am signed in

  Scenario: Join a room from the main page
    When I input "AZKR" into "room_id_input"
    And I have pressed join_room_button
    Then I should be directed to the create_player page