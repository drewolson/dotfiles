export CLICOLOR=1
export EDITOR='vim'
export FZF_DEFAULT_OPTS='--reverse'
export GOPATH=$HOME/go
export GPG_TTY=$(tty)
export HOMEBREW_NO_ANALYTICS=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export CPAIR_PAIR=drew
export ERL_AFLAGS="-kernel shell_history enabled"

if [[ -n "${XDG_RUNTIME_DIR}" ]]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
fi

export PATH=/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/heroku/bin:~/.mix/escripts:$HOME/bin:$GOPATH/bin:$PATH
