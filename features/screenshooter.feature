Feature: As a user I want to take a screenshot of the last page shown from my cucumber test for all
         the browsers I included in the configuration

Scenario: Single Browser screenshot
#  Given I performed a tunnel to browserstack
  And a simple application showing the user agent is running
  And I have the following configuration

"""
---
:credentials:
  :username: "colosso1"
  :password: "pYAeynvnb5CnUnv5i584"
:screenshots_folder: '/tmp'
:browsers:
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
  Then the screenshot '/tmp/The Screenshot/ie_10.0.jpg' should include the text 'MSIE 10.0'


Scenario: Take multiple screenshots
  And I have the following configuration
"""
---
:credentials:
  :username: "massimo54"
  :password: "4wpqYKWFaJCY9pdzvxdh"
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




Scenario: Cookies
  Given I have the following configuration
"""
---
:credentials:
  :username: "massimo54"
  :password: "4wpqYKWFaJCY9pdzvxdh"
:screenshots_folder: '/tmp'
:browsers:
  -
    :browser: IE
    :browser_version: 9.0
    :os: Windows
    :os_version: 7
"""
  And I performed a tunnel to browserstack
  And a simple application showing the user agent is running
  And I hit the simple web app
  When I drop a cookie 'cookie=max'
  And I hit the simple web app
  Then I should see 'hello max'
  When I execute this scenario
  """
  Feature: a feature
   @screenshot
  Scenario: The Screenshot
  When I hit the simple web app
  """
  Then the screenshot '/tmp/The Screenshot/IE_9.0.jpg' should include the text 'hello max'


