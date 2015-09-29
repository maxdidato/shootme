Feature: Shootme

Scenario: Take a screenshot
  Given I performed a tunnel to browserstack
  And I have the following configuration
  """
---
:credentials:
    :username: max706
    :password: nDHmVcRsS9stDEZi3pHy
:screenshots_folder: '/tmp'
  :browsers:
    -
      :browser: IE
      :browser_version: '7.0'
      :os: Windows
      :os_version: XP
    """
  When I execute this scenario
  """
  Feature: A Feature

  @screenshot
  Scenario: The Screenshot
  When I go on http://localhost:4567/
  """
  Then the screenshot '/tmp/The Screenshot/ie_7.0.jpg' should include the text 'MSIE 7.0'


Scenario: Take multiple screenshots
  And I have the following configuration
  """
---
:credentials:
    :username: massimiliano8
    :password: scQH4sZwU3TYhWygmvpp
:screenshots_folder: '/tmp'
  :browsers:
    -
      :browser: IE
      :browser_version: 11.0
      :os: Windows
      :os_versiuon: 7
    -
      :browser: IE
      :browser_version: 10.0
      :os: Windows
      :os_version: 7
    """
  When I execute this scenario
  """
  Feature: A Feature

  @screenshot
  Scenario: The Screenshot
  When I go on http://localhost:4567/
  """
  Then the screenshot '/tmp/The Screenshot/ie_11.0.jpg' should include the text '11.0'
  Then the screenshot '/tmp/The Screenshot/ie_10.0.jpg' should include the text '10.0'


  @multibrowser
  Scenario: Multibrowser
#    Given I performed a tunnel to browserstack

    And I have the following configuration
  """
---
:credentials:
    :username: max706
    :password: nDHmVcRsS9stDEZi3pHy
:screenshots_folder: '/tmp'
  :browsers:
    -
      :browser: IE
      :browser_version: 11.0
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
  When I go on http://localhost:4567/
  Then I should
  """


    @multibrowser
    Scenario: Hello e
      When I go on http://localhost:4567
      Then I should
      Then I see
