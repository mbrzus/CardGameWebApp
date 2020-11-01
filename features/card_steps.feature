Feature: display a list of cards held by different players
  and the deck that they are placed in.

  As a card manager
  So that I can browse the cards that are dealt to players
  belonging to different decks.

  Background: Cards have been added to the database

    Given the following cards have been dealt to players

      | Deck Number                   | Suit | Value | Owned By |
      | 1     | spades      | A  |     Jack        |
      | 1    | hearts      | 7  |    Daniel   |
      | 2    | diamonds      | Q  |   Jacob    |
      | 2    | hearts  | K  |   Sink1    |

    And I am on the card deck home page