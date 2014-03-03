Feature: 'User registration'
  In order to have access to the web site
  As a user
  I want to register myself  

Background:
  Given a user exists with email: "test@eventizer.com", password: "password"

Scenario: 'Succesfully sign in'
  Given I am on the sign in page 
  And I fill in "user email" with "test@eventizer.com"
  And I fill in "user password" with "password"
  When I press "Sign in"
  Then I should see "Signed in successfully"
  And I should be on the admin page

Scenario: 'Fail to sign in'
  Given I am on the sign in page 
  And I fill in "user email" with "wrong@eventizer.com"
  And I fill in "user password" with "wrong-password"
  When I press "Sign in"
  Then I should see "Invalid email or password."
  Then I should be on the sign in page
