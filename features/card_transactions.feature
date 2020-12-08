Feature: Give and draw cards from dealers and other players

  As an admin
  So that I can play the game by dealing out cards with my family


  Background: Rooms and payers have been added to the database
    Given The following rooms have been added to the database
    | id |
    |1   |
    |2   |
    |3   |

    Given The following players have been added to the database
    |id|  name | room_id |
    | 1| dealer| 1       |
    | 2| sink| 1       |
    | 3| Ram| 1       |
    | 4| Jacob| 1       |
    | 5| Jack| 1       |

    And I am on Room 1



  Scenario: Draw 5 cards from the dealer player
    Given I am on Room 1
    When I click on "draw_cards"
    Then I should be on the draw cards page

    When The dealer gives 5 cards from the draw_cards page to players 1,2,3
    And I click on "draw_cards_inside"
    Then I should be back at Room 1

    Scenario: Give cards to players
      Given I am on Room 1
      When I click on "give_cards"
      Then I should be on the give cards page

      When Player 4 gives cards to player 5
      And I click on "give_cards_inside"
      Then Player 5 must have the cards that player 4 had

