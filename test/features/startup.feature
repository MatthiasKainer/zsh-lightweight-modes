Feature: Minimal setup with an empty custom configuration

  Scenario: No mode selected is explicit
    When I run the following commands in `zsh`:
    """bash
    source ~/.zshrc
    echo $(env | grep "__ZSHMODES_ACTIVE_MODE")
    """
    Then the stderr should not contain anything
    Then the stdout should contain "-none-"

  Scenario: Running the help shows usage and installed modules
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    ls /opt/zsh-lightweight-modes/configs
    mode help
    """
    Then the stdout should contain "Usage:"
    And the stdout should contain "- minimal"
