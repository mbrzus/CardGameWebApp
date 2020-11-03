Feature: Create a new room to play cards in

  As a user of the service
  So that I can start a new game of cards with my family on the internet
  I want to be able to create a new room

  Background I am on the main page

  Scenario: Create New Room
    When I have pressed the create-room-button
    Then The Rooms table in the database should contain this room