Feature: User Creation and Login

  So that I can create and share knotebooks
  As a student or professor
  I want to be able to login
  
  Scenario: User signs up normally
    Given a new user
    When I go to the home page
    And I click "Login or Sign Up the old-fashioned way"
    And I click on "Don't have an account? Get one now!"
    And I fill in "user_login" with "JimmyJames"
    And I fill in "user_name" with "Jimmy James"
    And I fill in "user_password" with "j1mmy"
    And I fill in "user_password_confirmation" with "j1mmy"
    And I fill in "user_email" with "jimmy@jimmyjames.net"
    And I select "High School" from "user_difficulty"
    And I check "user_tou"
    And I press "Create My Account"
    Then I should see "Jimmy James"
  
  Scenario: Existing user wants to login
    Given a logged out user named "Jimmy"
    When I go to the home page
    And I click "Login or Sign Up the old-fashioned way"
    And I fill in "user_session_login" with "JimmyJames"
    And I fill in "user_session_password" with "j1mmyj4m3s"
    And I press "Login"
    Then I should see "Login Successful!"
    
  Scenario: Logged In User Logs Out
    Given a logged in user named "Jimmy"
    When I go to the home page
    And I click on "Log out"
    Then I should see "Logged out"
  
  Scenario: Signing up with RPX
    Given a new user
    When I go to the home page
    And I click "Login or Sign Up the old-fashioned way"
    And I click on "Don't have an account? Get one now!"