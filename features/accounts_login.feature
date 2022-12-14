Feature: Allow a user to login using their username and password

  As a user of the service
  So that I can signup for an account and login with my username and password
  To play the game

  Scenario: Sign up for an account to play the game
    When I am on the login page
    And I click on the signup button
    Then I should be on the sign_up page

  Scenario: Sign Up for an account
    When I am on the login page
    And I click on the signup button
    And I input "Shriram" into "signup_username"
    And I input "shriram@gmail.com" into "signup_email"
    And I input "password" into "signup_password"
    And I click on "signup_submit"
    Then A new account with the username "Shriram" should be created

  Scenario: Login with an existing account
    Given The account with username "Shriram" exists
    When I am on the login page
    And I input "Shriram" into "login_username"
    And I input "password" into "login_password"
    And I click on "login_submit"
    Then User "Shriram" should be authenticated


  Scenario: Sign up with invalid email
    When I am on the login page
    And I click on "signup"
    Then I should be on the sign_up page

    When I input "Name" into "signup_username"
    And I input "Name@com" into "signup_email"
    And I input "password" into "signup_password"
    And I click on "signup_submit"
    Then I should expect an invalid email error