Feature: Shootme

Scenario: Take a screenshot
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

