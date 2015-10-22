Feature: As a user I want to run my cucumber tests against all
  the browsers I included in the configuration


  Scenario: Multibrowser
    Given  a simple application showing the user agent is running
    Given I performed a tunnel to browserstack
    Given I have the following configuration

      """
      ---
      :credentials:
        :username: "max730"
        :password: "4uya9z4zNHXwxUsh9JcX"
      :screenshots_folder: '/tmp'
      :browsers:
        -
          :browser: IE
          :browser_version: 9.0
          :os: Windows
          :os_version: 7
        -
          :browser: IE
          :browser_version: 10.0
          :os: Windows
          :os_version: 7
      """
    When I execute this scenario
      """
        Feature: A Feature

        @multibrowser
        Scenario: Ther Screenshot
        When I hit the simple web app
        Then I should see 'hello'
      """
    Then I should see the simple web app hit by the following browsers
      | MSIE 9.0  |
      | MSIE 10.0 |


  Scenario: Failing Scenario
    Given a web app which make test failing using 'MSIE 7.0' is running
    And I performed a tunnel to browserstack
    And I have the following configuration
      """
      ---
      :credentials:
        :username: "max730"
        :password: "4uya9z4zNHXwxUsh9JcX"
      :screenshots_folder: '/tmp'
      :browsers:
        -
          :browser: IE
          :browser_version: 7.0
          :os: Windows
          :os_version: XP
      """
    When I execute this scenario
      """
      Feature: A Feature
       @multibrowser
        Scenario: Ther Screenshot
        When I hit the simple web app
        Then I should see 'hello'
      """
    Then the scenario should fail

