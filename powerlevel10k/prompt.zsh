
prompt_currentMode() {
    local icon="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_p10k_prompt_icon"
    local text="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_p10k_prompt_text"
    local foregroundColor="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_p10k_prompt_foregroundColor"
    local backgroundColor="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_p10k_prompt_backgroundColor"
    icon="${(P)icon}"
    text="${(P)text}"
    foregroundColor="${(P)foregroundColor}"
    backgroundColor="${(P)backgroundColor}"
    if [ ! -z "$icon" ]; then
      icon="$icon"
    else
      icon=💢
    fi
    p10k segment -i $icon -t "$text" -f "$foregroundColor" -b "$backgroundColor"
}

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    # =========================[ Line #1 ]=========================
    currentMode
    dir                     # current directory
    vcs                     # git status
    # =========================[ Line #2 ]=========================
    newline                 # \n
    # prompt_char           # prompt symbol
  )