Feature: A custom configuration that specifies a git environment

  Background: With a config that uses git
    And a file named "/opt/zsh-lightweight-modes/configs/git.config" with:
    """
    git:
      user: 
        name: Example User Name For test
        email: example.email.for.test@example.com

    """

Scenario: Switching to the custom mode with the git should set the specified variables
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    mode git
    git config --global --get user.name
    git config --global --get user.email
    """
    Then the stdout should contain "Example User Name For test"
    Then the stdout should contain "example.email.for.test@example.com"
    And the stderr should not contain anything

  Scenario: Switching to the custom mode with the git config and back to another should clear all the specified settings
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    mode git
    mode minimal
    git config --global --get user.name
    git config --global --get user.email
    """
    Then the stdout should not contain "Example User Name For test"
    Then the stdout should not contain "example.email.for.test@example.com"
    And the stderr should not contain anything