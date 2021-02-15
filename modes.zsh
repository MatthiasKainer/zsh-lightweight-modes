BASEDIR=$(dirname "$0")
local __ZSHMODES=()
local __ZSHMODES_MODULES=()
local __ZSHMODES_CURRENT_MODE=""
export __ZSHMODES_ACTIVE_MODE="-none-"
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
    if [[ " help " == " $1 " ]]; then
        echo "########################################"
        echo "#       zsh-lightweight-modes          #"
        echo "########################################"
        echo 
        echo "Usage:"
        echo "      mode [mode]"
        echo  
        echo "Modes available:          (* is active)"
        for f in $__ZSHMODES; do
            if [[ " $__ZSHMODES_CURRENT_MODE " == " $f " ]]; then
                echo "- $f *"
            else
                echo "- $f"
            fi
        done
        return 0
    fi
    if [[ "" == "$1" ]]; then
        printModes
        return 0
    fi

    if [[ ! " ${__ZSHMODES[@]} " =~ " $1 " ]]; then
        echo "mode not found"
        return -1
    fi

    __ZSHMODES_CURRENT_MODE=$1
    export __ZSHMODES_ACTIVE_MODE="$__ZSHMODES_CURRENT_MODE"

    for f in $__ZSHMODES_MODULES; do
        eval "config_$f"
    done

}

printModes() {
    echo "$__ZSHMODES[@]" 
}

_mode() {
    compadd $__ZSHMODES[@]
}

compdef _mode mode
