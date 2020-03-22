Feature: A custom configuration that specifies an nvm environment

  Background: With a minimal config
    Given a file named "/opt/zsh-lightweight-modes/configs/minimal.config" with:
    """

    """
    And a file named "/opt/zsh-lightweight-modes/configs/nvm.config" with:
    """
    nvm:
      version: v13.11.0
    """
    And I run the following commands with `zsh`:
    """
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    echo "[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"" >> ~/.zshrc
    source ~/.zshrc
    nvm install v0.10.32
    nvm alias default 0.10.32
    """
    And I run the following commands with `zsh`:
    """
    source ~/.zshrc
    nvm install v13.11.0
    """

Scenario: Switching to the custom mode with the nvm should set the specified variables
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    mode nvm
    nvm ls
    """
    Then the stdout should contain "->     v13.11.0"
    And the stderr should not contain anything

  Scenario: Switching to the custom mode with the nvm config and back to another should clear all the specified settings
    When I run the following commands with `zsh`:
    """
    source ~/.zshrc
    mode git
    mode minimal
    nvm ls
    """
    Then the stdout should contain "->     v0.10.32"
    And the stderr should not contain anything