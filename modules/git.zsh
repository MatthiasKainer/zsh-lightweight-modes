local config_git() {
    if [ -z "$__ZSHMODES_CURRENT_MODE" ]; then
        git config --global --unset user.name
        git config --global --unset user.email
        return
    fi
    local user="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_git_user_name"
    user="${(P)user}"
    local email="__ZSHMODES_${__ZSHMODES_CURRENT_MODE}_git_user_email"
    email="${(P)email}"
    if [ -z "$user" ]; then
        git config --global --unset user.name
    else
        git config --global user.name $user
    fi
    if [ -z "$email" ]; then
        git config --global --unset user.email
    else
        git config --global user.email $email
    fi
}

orig_git=$(whereis git)
if [ -e /usr/local/bin/git ]; then
    orig_git="/usr/local/bin/git"
elif [[ $orig_git == "git:"* ]]; then
    orig_git=$(echo $orig_git | awk '{ print $2; }')
fi
local do_git() {
  config_git
  whitespace="[[:space:]]"
  if [[ "$($orig_git config user.name)" = "" ]]; then
    echo "git disabled, no user configured. Change to a mode with a git user first"
    (exit 1)
  else
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
  fi
}

whereis_git() {
    echo "$orig_git"
}

alias git='do_git'
config_git