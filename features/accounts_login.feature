Feature: Allow a user to login using their username and password

  As a user of the service
  So that I can signup for an account and login with my username and password
  To play the game

  Scenario: Sign up for an account to play the game
    When I am a new user
    And I have pressed "sign_up_button"
    Then I should be on the sign up page

    When I sign up with the username "Shriram"
    And I sign up with the email "shriram@gmail.com"
    And I put in the password "password"
    And I have pressed "create_new_account"