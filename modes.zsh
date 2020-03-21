BASEDIR=$(dirname "$0")
local __ZSHMODES=()
local __ZSHMODES_MODULES=()
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

for f in $(ls $BASEDIR/modules/*.zsh); do
    source "$f"
    __ZSHMODES_MODULES+=($(basename "$f" | sed -e 's/\.zsh$//'))
done

mode() {
    if [[ ! " ${__ZSHMODES[@]} " =~ " $1 " ]]; then
        echo "mode not found"
        return -1
    fi

    __ZSHMODES_CURRENT_MODE=$1

    for f in $__ZSHMODES_MODULES; do
        eval "config_$f"
    done
}

_mode() {
    compadd $__ZSHMODES[@]
}

compdef _mode mode

source "$BASEDIR/powerlevel10k/prompt.zsh"