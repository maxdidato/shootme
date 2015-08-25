Feature: Shootme

Scenario: Take a screenshot
  And I have the following configuration
  """
    browsers:
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
  Then I should see a screenshot including MSIE9.0
#
#  @screenshot
#  Scenario: Take a screenshot
##  Given I performed a tunnel to browserstack
#And I have the following configuration
#    """
#    browsers:
#      -
#        :browser: IE
#        :browser_version: '7.0'
#        :os: Windows
#        :os_version: XP
#    """
#   Given I go on http://localhost:4567/
#    Then I should see a screenshot including MSIE9.0
