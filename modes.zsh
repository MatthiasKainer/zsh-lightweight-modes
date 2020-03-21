BASEDIR=$(dirname "$0")
local __ZSHMODES=()
local __ZSHMODES_CURRENT_MODE=""
local loadConfig() {
    emulate -L bash
    source "$BASEDIR/config.sh"

    for f in $(ls $BASEDIR/configs/*.config); do
        eval $(parse_config $f )
        __ZSHMODES+=($(basename "$f" | sed -e 's/\.config$//'))
    done
}
loadConfig

local expand() {
  eval printf '%s' "\"\${$1?}\""
}

local config_jenv() {
    local var="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_jenv_version"
    var="${(P)var}"
    if [ ! -z "$var" ]; then
        jenv shell "$var"
    fi
}
local config_nvm() {
    local var="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_nvm_version"
    var="${(P)var}"
    if [ ! -z "$var" ]; then
        nvm use "$var"
    fi
}

local config_ssh() {
    ssh-add -D
    local var="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_ssh_file"
    var="${(P)var}"
    if [ ! -z "$var" ]; then
        ssh-add "$var"
    fi
}

local config_git() {
    if [ -z "$__ZSHMODES_CURRENT_MODE" ]; then
        return
    fi
    local user="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_git_user_name"
    user="${(P)user}"
    local email="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_git_user_email"
    email="${(P)email}"
    git config --global user.name $user
    git config --global user.email $email
}

local config_env() {
    if [ -z "$__ZSHMODES_CURRENT_MODE" ]; then
        return
    fi
    envs="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_env"
    envsToSet=("${(@f)$(local | grep "${envs}_" | sed -e "s/${envs}_//")}")
    old="__ZSHMODES_current_env"
    oldEnvs="${(P)old}"
    if [ ! -z "$oldEnvs" ]; then
        oldEnvs=(${(@f)oldEnvs})
        for oldEnv in "${oldEnvs[@]}"
        do
            unset "$oldEnv"
        done
    fi
    newEnvs=()
    if [ ! -z "$envsToSet" ]; then
        for env in "${envsToSet[@]}"
        do
            keyVal=("${(@s/=/)env}") 
            newEnvs+=($keyVal[1])
            export "${keyVal[1]}"="${keyVal[2]}"
        done
    fi
    export "$old"="${(F)newEnvs}"
}

mode() {
    __ZSHMODES_CURRENT_MODE=$1

    if [[ ! " ${__ZSHMODES[@]} " =~ " ${__ZSHMODES_CURRENT_MODE} " ]]; then
        echo "mode not found"
        return -1
    fi
    config_ssh
    config_git
    config_env
    config_jenv
    config_nvm
}

_mode() {
    compadd $__ZSHMODES[@]
}

orig_git=$(whereis git)
local do_git() {
  config_git
  whitespace="[[:space:]]"
  args=()
  for i in "$@"
  do
    if [[ $i =~ $whitespace ]]
    then
        i=\"$i\"
    fi
    args+=("$i")
  done
  eval $orig_git $args
}

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

alias git='do_git'
config_git

compdef _mode mode