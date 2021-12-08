autoload -U compinit
compinit
autoload -U colors
colors

setopt no_auto_menu
setopt prompt_subst
setopt no_global_rcs
set -o emacs

alias vim="nvim"

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
[[ -s $HOME/.asdf/plugins/java/set-java-home.zsh ]] && source $HOME/.asdf/plugins/java/set-java-home.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -s /opt/homebrew/opt/llvm@12 ]] && export LLVM_SYS_120_PREFIX=/opt/homebrew/opt/llvm@12

test -r ~/.opam/opam-init/init.zsh && . ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export PATH=/opt/homebrew/opt/llvm@12/bin:/opt/homebrew/bin:~/.mix/escripts:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH

[[ -s /opt/homebrew/opt/llvm@12 ]] && export PATH=/opt/homebrew/opt/llvm@12/bin:$PATH
