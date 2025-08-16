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

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -x "$(command -v xcrun)" ] && export C_INCLUDE_PATH="`xcrun --show-sdk-path`/usr/include/ffi"
[[ -s $HOME/.asdf/plugins/java/set-java-home.zsh ]] && source $HOME/.asdf/plugins/java/set-java-home.zsh
[ -f $HOME/.ghcup/env ] && source $HOME/.ghcup/env
[[ ! -z "$XDG_RUNTIME_DIR" ]] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
[ -f $HOME/.asdf/plugins/dotnet-core/set-dotnet-home.zsh ] && source $HOME/.asdf/plugins/dotnet-core/set-dotnet-home.zsh
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null
[[ -s $HOME/.cargo/env ]] && source $HOME/.cargo/env
[ -x "$(command -v jj)" ] && source <(COMPLETE=zsh jj)
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"

if [ -d /opt/homebrew/opt/llvm@12 ]; then
  export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"
  export PATH=/opt/homebrew/opt/llvm@12/bin:$PATH
fi

export PATH=${ASDF_DATA_DIR:-$HOME/.asdf}/shims:/opt/homebrew/opt/libpq/bin:~/.mix/escripts:$HOME/.local/bin:$GOPATH/bin:$HOME/.dotnet/tools:$HOME/.elan/bin:$PATH
