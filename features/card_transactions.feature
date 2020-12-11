Feature: Give and draw cards from dealers and other players

  As an admin
  So that I can play the game by dealing out cards with my family


  Background: Rooms and payers have been added to the database
    Given The following rooms have been added to the database
    | id| player_limit| room_token|
    |  5|           10|       AZKR|
    |  6|           10|       AZKL|
    |  7|           10|       AZKP|

    Given The following players have been added to the database
    |  id|    name| room_id|
    | 215|  dealer|       5|
    | 216|    sink|       5|
    | 217| Shriram|       5|
    | 218|   Jacob|       5|
    | 219|    Jack|       5|

    And I am signed in
    And I am on Room 5

  Scenario: Draw 5 cards from the dealer player
    Given I am on a Room and I have logged in
    When I click on "draw_cards"
    Then I should be on the draw cards page

    When The dealer gives 5 cards from the draw cards page to player "Shriram"
    And I click on "draw_cards_inside"
    Then I should be back at Room 1

    Scenario: Give cards to players
      Given I am on a Room and I have logged in
      When I click on "give_cards"
      Then I should be on the give cards page

      When Player "Shriram" gives cards to player "sink"
      And I click on "give_cards_inside"
      Then Player "sink" must have the cards that player "Shriram" had

