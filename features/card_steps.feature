Feature: display a list of cards held by different players
  and the deck that they are placed in.

  As a card manager
  So that I can browse the cards that are dealt to players
  belonging to different decks.

  Background: Cards have been added to the database

    Given the following cards have been dealt to players

      | Deck Number                   | Suit | Value |
      | 1     | spades      | A  |
      | 1    | hearts      | 7  |
      | 2    | diamonds      | Q  |
      | 2    | hearts  | K  |

    And I am on the card deck home page

