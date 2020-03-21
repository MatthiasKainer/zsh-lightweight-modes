local config_nvm() {
    local var="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_nvm_version"
    var="${(P)var}"
    if [ ! -z "$var" ]; then
        nvm use "$var"
    else
        nvm use default 2> /dev/null
    fi
}