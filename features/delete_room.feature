Feature: Delete an existing room
  As a room administrator
  So that I can remove old rooms and create new ones
  I want to be able to delete an existing room


  Background: rooms and players have been added to the database

    Given The following rooms have been added to the database
      | id| player_limit| room_token|
      |  5|           10|       AZKR|
      |  6|           10|       AZKL|
      |  7|           10|       AZKP|

    Given The following players have been added to the database
      |  id|    name| room_id|
      | 215|  dealer|       5|
      | 216|    sink|       5|
      | 217| shriram|       5|
      | 218|   Jacob|       5|
      | 219|    Jack|       5|

    And I am signed in
    And I am on Room 5

  Scenario: End an existing game on the room
    When I click on "end_game"
    Then I should be on the main page with the notice "Game ended successfully. Thank you for playing!"


  Scenario: Reset an existing game on the room
    When I click on "reset_game"
    Then I still should be on the same room with the notice "Game reset successfully!"
