Feature: Allow a user to login using their username and password

  As a user of the service
  So that I can signup for an account and login with my username and password
  To play the game

  Scenario: Sign up for an account to play the game
    When I am on the "login" page
    And I click on "sign_up_button"
    Then I should be on the sign_up page

    When I input "Shriram" into "signup_username"
    And I input "shriram@gmail.com" into "signup_email"
    And I input "password" into "signup_password"
    And I click on "create_new_account"
    Then A new account with the username "Shriram" should be created


  Scenario: Login with an existing account
    When I am on the "login" page
    And I input "Shriram" into "login_username"
    And I input "password" into "login_password"
    And I click on "login_submit"
    Then user "Shriram" should be authenticated