Scenario: Visiting the knotebooks index
  Given a new user
  When I go to the knotebooks page
  Then I should see "All Knotebooks"

Scenario: Viewing a knotebook
  Given a new user
  And a knotebook with title: "Pa Pee Kur"
  When I go to the knotebook's page
  Then I should see "Pa Pee Kur"