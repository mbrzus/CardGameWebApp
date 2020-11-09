Feature: edit an existing card

  Scenario: Edit a card from the card database

    Given I have added a card with suit "Spades" and value "A" and owned by "Shriram"
    And I have visited the Details about the card with suit "Spades" and value "A" in deck "1"

    When I have edited the card with suit "Spades" and value "A" to be owned by "Sink1"
    And I am on the card deck home page
    Then I should see a card entry with suit "Spades", value "A" and owned by "Sink1"