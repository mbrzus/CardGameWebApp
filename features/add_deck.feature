Feature: Allow manager to add a new deck in a room

  Scenario:  Add a new deck (Declarative)
    When I have added a deck in room number "1"
    And I am on the card deck home page
    Then I should see a list of cards with all suits and values in room id "1"