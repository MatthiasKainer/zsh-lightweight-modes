Feature: Sets up an environment for the other tests to avoid repetition

  Background: With a minimal config
    Given a file named "/opt/zsh-lightweight-modes/configs/minimal.config" with:
    """

    """

  Scenario: Switching to the created custom mode
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    mode minimal
    echo $(env | grep "__ZSHMODES_ACTIVE_MODE")
    mode help
    """
    # Expose an env variable in case someone cares
    Then the stdout should contain "__ZSHMODES_ACTIVE_MODE=minimal"
    # show the current mode as active in help
    And the stdout should contain "- minimal *" 
    And the stderr should not contain anything