autoload -U compinit
compinit
autoload -U colors
colors

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

setopt no_auto_menu
setopt prompt_subst
setopt no_global_rcs
set -o emacs

if [ -f /usr/libexec/java_home ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi

git_prompt_info() {
  ref=$($(which git) symbolic-ref HEAD 2> /dev/null) || return
  user=$($(which git) config user.name 2> /dev/null)
  echo " (${user}@${ref#refs/heads/})"
}

export PROMPT='%{$fg_bold[green]%}%n:%{$fg_bold[blue]%}%~%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}%(!.#.$) '

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

[[ -s /usr/local/opt/nvm/nvm.sh ]] && source /usr/local/opt/nvm/nvm.sh

. $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
