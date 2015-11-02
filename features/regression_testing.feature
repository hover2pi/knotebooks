Feature: Regression Testing
  In order to have a great Knotebooks experience
  As a user
  I want to never see these bugs again!

  Scenario: Viewing a User's Website when the Description is missing
    Given a user exists with website: "http://my.website.com", website_description: ""
    When I go to the user's page
    Then I should see "http://my.website.com"

  Scenario: Viewing a User's Website Description
    Given a user exists with website: "http://my.website.com", website_description: "My Website"
    When I go to the user's page
    Then I should see "My Website"

  Scenario: Lesson Abstract is 400 characters
    Given a valid knotebook exists with abstract: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras in ultricies ipsum. Aenean lobortis arcu ac felis dignissim vehicula. Sed dapibus nibh porttitor eros pulvinar sit amet auctor justo molestie. Duis congue purus at nibh tincidunt accumsan. Ut pulvinar augue et arcu ultricies commodo. Integer imperdiet euismod tellus. Etiam pretium pretium posuere. Donec eu metus sit amet orci cras amet."
    When I go to the knotebook's page
    Then I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras in ultricies ipsum. Aenean lobortis arcu ac felis dignissim vehicula. Sed dapibus nibh porttitor eros pulvinar sit amet auctor justo molestie. Duis congue purus at nibh tincidunt accumsan. Ut pulvinar augue et arcu ultricies commodo. Integer imperdiet euismod tellus. Etiam pretium pretium posuere. Donec eu metus sit amet orci cras amet."
  
  
  