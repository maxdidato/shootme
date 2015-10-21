Feature: As a user I want to take a screenshot of the last page shown from my cucumber test for all
         the browsers I included in the configuration

Scenario: Single Browser screenshot
  Given I performed a tunnel to browserstack
  And a simple application showing the user agent is running
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
    :browser_version: 11.0
    :os: Windows
    :os_version: 7
"""
  When I execute this scenario
  """
  Feature: A Feature

  @screenshot
  Scenario: The Screenshot
  Then I hit the simple web app
  """
  Then the screenshot '/tmp/The Screenshot/ie_11.0.jpg' should include the text 'rv:11.0'


Scenario: Take multiple screenshots
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

  @screenshot
  Scenario: The Screenshot
  Then I hit the simple web app
  """
  Then the screenshot '/tmp/The Screenshot/ie_11.0.jpg' should include the text '11.0'
  Then the screenshot '/tmp/The Screenshot/ie_10.0.jpg' should include the text '10.0'

