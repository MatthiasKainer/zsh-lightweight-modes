Feature: A custom configuration that sets an environment variable

  Background: With a minimal config
    Given a file named "/opt/zsh-lightweight-modes/configs/minimal.config" with:
    """

    """
    And a file named "/opt/zsh-lightweight-modes/configs/env.config" with:
    """
    env: 
      var_for_testing: env variable set for testing

    """

  Scenario: 
    Switching to the custom mode with the environment variable
    should set the specified variables
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    mode env
    echo $(env | grep "var_for_testing")
    """
    Then the stdout should contain "var_for_testing='env variable set for testing'"
    And the stderr should not contain anything

  Scenario: 
    Switching to the custom mode with the environment variable and back
    to another should clear all the specified variables
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    mode env
    mode minimal
    echo "Should be empty: -$var_for_testing-"
    """
    Then the stdout should contain "Should be empty: --"
    And the stderr should not contain anything