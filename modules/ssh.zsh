local config_ssh() {
    ssh-add -D
    local var="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_ssh_file"
    var="${(P)var}"
    if [ ! -z "$var" ]; then
        ssh-add "$var"
    fi
}