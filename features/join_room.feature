Feature: Join an existing room to play cards in

  As a user of the service
  So that I can play a card game with a small group of people
  I want to be able to join am existing room

  Given the following rooms exist in the database:
  | id |
  | 1  |
  | 2  |

  Scenario: Join a room from the main page
    Given I am on the main page
    When I input "1" into room_id_input
    And I have clicked join_room_button
    Then I should be directed to the create_player page