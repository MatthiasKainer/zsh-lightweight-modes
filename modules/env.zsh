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