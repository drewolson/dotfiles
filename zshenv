autoload -U compinit
compinit
autoload -U colors
colors

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

setopt no_auto_menu
setopt prompt_subst
set -o emacs

export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/heroku/bin:~/.cabal/bin:$PATH
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export EDITOR='vim'
export GREP_OPTIONS='--color=auto'
export GOPATH=~/go

if [ -f /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

git_prompt_info() {
  ref=$($(which git) symbolic-ref HEAD 2> /dev/null) || return
  user=$($(which git) config user.name 2> /dev/null)
  echo " (${user}@${ref#refs/heads/})"
}

export PROMPT='%{$fg_bold[green]%}%n@%m:%{$fg_bold[blue]%}%~%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}%(!.#.$) '

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

[[ -s /usr/local/opt/nvm/nvm.sh ]] && source /usr/local/opt/nvm/nvm.sh
