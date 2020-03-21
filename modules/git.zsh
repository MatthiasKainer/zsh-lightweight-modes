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
    git config --global user.name $user
    git config --global user.email $email
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

alias git='do_git'
config_git