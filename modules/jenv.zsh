local config_jenv() {
    local var="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_jenv_version"
    var="${(P)var}"
    if [ ! -z "$var" ]; then
        jenv shell "$var"
    else 
        jenv shell --unset 2> /dev/null
    fi
}