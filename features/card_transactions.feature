Feature: Give and draw cards from dealers and other players

  As an admin
  So that I can play the game by dealing out cards with my family


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



  Scenario: Draw 5 cards from the dealer player
    Given I am on Room 2
    When I press draw_cards
    And I am on the draw_cards page
    Then I should be able to select players to give 5 cards from the dealer

    Scenario: Give cards to players
      Given I am on Room 2
      When I press give_cards
      And I am on the give_cards page
      Then I should be able to select "Ram" and give cards to the player

