BASEDIR=$(dirname "$0")
source "$BASEDIR/config.sh"; # load the config library functions

mode=$1
if [[ ! "${__ZSHMODES[@]}" =~ "${mode}" ]]; then
    echo "mode not found"
    exit -1
fi
user="__ZSHMODES_${mode}_git_user_name"
echo $user
user="${!user}"
echo $user