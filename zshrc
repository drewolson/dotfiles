autoload -U compinit
compinit
autoload -U colors
colors

setopt no_auto_menu
setopt prompt_subst
setopt no_global_rcs
set -o emacs

ls --color=auto &> /dev/null && alias ls='ls --color=auto'

git_prompt_info() {
  ref=$($(which git) symbolic-ref HEAD 2> /dev/null) || return
  user=$($(which git) config user.name 2> /dev/null)
  echo " (${user}@${ref#refs/heads/})"
}

export PROMPT='%{$fg_bold[green]%}%n:%{$fg_bold[blue]%}%~%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}%(!.#.$) '

[[ -s $HOME/.asdf/asdf.sh ]] && source $HOME/.asdf/asdf.sh
[[ -s $HOME/.asdf/completions/asdf.bash ]] && source $HOME/.asdf/completions/asdf.bash

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
