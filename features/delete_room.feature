Feature: Delete an existing room
  As a room administrator
  So that I can remove old rooms and create new ones
  I want to be able to delete an existing room


  Background: rooms and players have been added to the database

    Given The following rooms have been added to the database
      | id |
    |1   |
    |2   |
    |3   |

    Given The following players have been added to the database
    |id|  name | room_id |
    | 1| dealer| 1       |
    | 2| sink| 1       |
    | 3| Ram| 1      |
    | 4| Jacob| 1       |
    | 5| Jack| 1       |



  Scenario: End an existing game on the room

    Given I am on a Room and I have logged in
    When I click on "end_game"
    Then I should be on the main page with the notice "Game ended successfully. Thank you for playing!."


  Scenario: Reset an existing game on the room
    Given I am on a Room and I have logged in
    When I click on "reset_game"
    Then I still should be on the same room with the notice "Game reset successfully!"
