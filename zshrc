autoload -U compinit
compinit
autoload -U colors
colors

setopt no_auto_menu
setopt prompt_subst
setopt no_global_rcs
set -o emacs

if [ ! $(uname -s) = "Darwin" ]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
fi

ls --color=auto &> /dev/null && alias ls='ls --color=auto'

git_prompt_info() {
  ref=$($(which git) symbolic-ref HEAD 2> /dev/null) || return
  echo " (${ref#refs/heads/})"
}

export PROMPT='%{$fg_bold[green]%}%n:%{$fg_bold[blue]%}%~%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}%(!.#.$) '

[[ -s $HOME/.asdf/asdf.sh ]] && source $HOME/.asdf/asdf.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -r ~/.opam/opam-init/init.zsh && . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export PATH=/opt/homebrew/bin:~/.mix/escripts:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH
