Feature: Scheduling
  Background:
    Given there is no Newsletter named "Superior Soy Beans Discount!"
    And there is no "Junk-food addicts" Recipient List
    And there is no identity named "Hidden"
    And I add the "Hidden" Identity
    And I add a Newsletter named "Superior Soy Beans Discount!" written by "Hidden"
    And I add a Recipient List named "Junk-food addicts"
    And "Joe" subscribes to "Junk-food addicts"
    And I add "Junk-food addicts" to "Superior Soy Beans Discount!"
    And "Superior Soy Beans Discount!" is not scheduled
  @sendgrid_scheduling_newsletter
  Scenario: Scheduling a Newsletter
    When I schedule "Superior Soy Beans Discount!" for "tomorrow"
    Then it should deliver "Superior Soy Beans Discount!" at "tomorrow"
  @sendgrid_descheduling_newsletter
  Scenario: Deschedule a Newsletter
    Given I schedule "Superior Soy Beans Discount!" for "tomorrow"
    When I deschedule "Superior Soy Beans Discount!"
    Then it should not deliver "Superior Soy Beans Discount!"
