export PATH="$HOME/bin:$PATH"
# export ZSH="$HOME/.oh-my-zsh"

unsetopt nomatch

# USE_OH_MY_ZSH="false"
# ZSH_THEME="hammer"

# Case sensitive completion
CASE_SENSITIVE="true"

# plugins=(asdf bundler docker gem git npm osx pip ruby tmux yarn)

if [ -e "$SHELL_COMPLETION_DIR" ]; then
  if [ `ls -1 $SHELL_COMPLETION_DIR/*.zsh 2>/dev/null | wc -l` -gt 0 ]; then
    for rcfile in $SHELL_COMPLETION_DIR/*.zsh; do
      . $rcfile
    done
  fi
fi

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

###############################
#         Environment         #
###############################
set -o emacs

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export EDITOR='vim'
export VISUAL='vim'

export HISTSIZE=10000
export SAVEHIST=10000

export ERL_AFLAGS="-kernel shell_history enabled"

export ASDF_DATA_DIR=/Users/hammer/.asdf
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# if [[ "$USE_OH_MY_ZSH" == "true" ]]; then
#   source $ZSH/oh-my-zsh.sh
# fi

# . $HOME/.asdf/asdf.sh

# append completions to fpath
# fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

###############################
#       Command Prompt        #
###############################

function __promptline_host {
    local hostname=$(hostname)

    case "${hostname}" in
        Kobe.local)     printf "Kobe" ;;
        Miyamoto.local) printf "Miyamoto" ;;
        Sendai.local)   printf "Sendai" ;;
        *)              printf "${hostname}" ;;
    esac
}

function __promptline_last_exit_code {
  [[ $last_exit_code -gt 0 ]] || return 1;

  printf "%s" "$last_exit_code"
}

function __promptline_vcs_branch {
  local branch
  local branch_symbol=" "

  # git
  if hash git 2>/dev/null; then
    if branch=$( { git symbolic-ref --quiet HEAD || git rev-parse --short HEAD; } 2>/dev/null ); then
      branch=${branch##*/}
      printf "%s" "${branch_symbol}${branch:-unknown}"
      return
    fi
  fi
  return 1
}

function __promptline_cwd {
  local dir_limit="3"
  local truncation="⋯"
  local first_char
  local part_count=0
  local formatted_cwd=""
  local dir_sep="  "
  local tilde="~"

  local cwd="${PWD/#$HOME/$tilde}"

  # get first char of the path, i.e. tilde or slash
  first_char=${cwd[1,1]}


  # remove leading tilde
  cwd="${cwd#\~}"

  while [[ "$cwd" == */* && "$cwd" != "/" ]]; do
    # pop off last part of cwd
    local part="${cwd##*/}"
    cwd="${cwd%/*}"

    formatted_cwd="$dir_sep$part$formatted_cwd"
    part_count=$((part_count+1))

    [[ $part_count -eq $dir_limit ]] && first_char="$truncation" && break
  done

  printf "%s" "$first_char$formatted_cwd"
}

function __promptline_wrapper {
    # wrap the text in $1 with $2 and $3, only if $1 is not empty
    # $2 and $3 typically contain non-content-text, like color escape codes and separators

    [[ -n "$1" ]] || return 1
    printf "%s" "${2}${1}${3}"
}

function __promptline_left_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  # Section A
  slice_prefix="${a_bg}${sep}${a_fg}${a_bg}${space}"
  slice_suffix="$space${a_sep_fg}"
  slice_joiner="${a_fg}${a_bg}${alt_sep}${space}"
  slice_empty_prefix="${a_fg}${a_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  __promptline_wrapper "$(__promptline_host)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # Section B
  slice_prefix="${b_bg}${sep}${b_fg}${b_bg}${space}"
  slice_suffix="$space${b_sep_fg}"
  slice_joiner="${b_fg}${b_bg}${alt_sep}${space}"
  slice_empty_prefix="${b_fg}${b_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  __promptline_wrapper "hammer" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # Section C
  slice_prefix="${c_bg}${sep}${c_fg}${c_bg}${space}"
  slice_suffix="$space${c_sep_fg}"
  slice_joiner="${c_fg}${c_bg}${alt_sep}${space}"
  slice_empty_prefix="${c_fg}${c_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  __promptline_wrapper "$(__promptline_cwd)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  # # Section Y
  slice_prefix="${y_bg}${sep}${y_fg}${y_bg}${space}"
  slice_suffix="$space${y_sep_fg}"
  slice_joiner="${y_fg}${y_bg}${alt_sep}${space}"
  slice_empty_prefix="${y_fg}${y_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  __promptline_wrapper "$(__promptline_vcs_branch)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }

  printf "%s" "${reset_bg}${sep}$reset$space"
}

function __promptline_right_prompt {
  local slice_prefix slice_empty_prefix slice_joiner slice_suffix

  # Section Warn
  slice_prefix="${warn_sep_fg}${rsep}${warn_fg}${warn_bg}${space}"
  slice_suffix="$space${warn_sep_fg}"
  slice_joiner="${warn_fg}${warn_bg}${alt_rsep}${space}"
  slice_empty_prefix=""
  # section "warn" slices
  __promptline_wrapper "$(__promptline_last_exit_code)" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; }

  # close sections
  printf "%s" "$reset"
}

function __promptline {
  local last_exit_code="${PROMPTLINE_LAST_EXIT_CODE:-$?}"

  local esc=$'\e[' end_esc=m
  local noprint='%{' end_noprint='%}'
  # local noprint='' end_noprint=''
  local wrap="$noprint$esc" end_wrap="$end_esc$end_noprint"
  local space=" "
  local sep=""
  local rsep=""
  local alt_sep=""
  local alt_rsep=""
  local reset="${wrap}0${end_wrap}"
  local reset_bg="${wrap}49${end_wrap}"
  local a_fg="${wrap}38;5;255${end_wrap}"
  local a_bg="${wrap}48;5;31${end_wrap}"
  local a_sep_fg="${wrap}38;5;30${end_wrap}"
  local b_fg="${wrap}38;5;254${end_wrap}"
  local b_bg="${wrap}48;5;237${end_wrap}"
  local b_sep_fg="${wrap}38;5;237${end_wrap}"
  local c_fg="${wrap}38;5;254${end_wrap}"
  local c_bg="${wrap}48;5;234${end_wrap}"
  local c_sep_fg="${wrap}38;5;234${end_wrap}"
  local warn_fg="${wrap}38;5;232${end_wrap}"
  local warn_bg="${wrap}48;5;166${end_wrap}"
  local warn_sep_fg="${wrap}38;5;166${end_wrap}"
  local y_fg="${wrap}38;5;254${end_wrap}"
  local y_bg="${wrap}48;5;237${end_wrap}"
  local y_sep_fg="${wrap}38;5;237${end_wrap}"

  PROMPT="$(__promptline_left_prompt)"
  RPROMPT="$(__promptline_right_prompt)"
}

PROMPT_COMMAND=__promptline
precmd() { eval "$PROMPT_COMMAND" }

alias emacs="emacs -nw"
alias patest="php artisan test"
alias pat='php artisan test:affected --parallel'
alias pam="php artisan migrate"
alias pa="php artisan"
alias cdsp="claude --dangerously-skip-permissions"

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down 


clean() {
	if [ "$#" -eq 1 ]
	then
		filename=$1
		fileext="${filename##*.}"
		echo "Removing metadata from $filename"
		case "$fileext" in
		    mkv)
			mkvpropedit "$filename" --tags all:
			;;
		    m4v|mp4)
			AtomicParsley "$filename" --metaEnema --overWrite
			;;
		    *)
			echo "unknown filetype: $fileext ($filename)"
			;;
		esac
	else
		for f in **/*.{mkv,mp4,m4v}; do
			[ -f "$f" ] || continue
			clean $f
		done
	fi
}

convert_mkv() {
	if [ "$#" -eq 1 ]
	then
		filename=$1
                basepath="${filename:r}"
		echo "Converting $filename to MKV"
                ffmpeg -fflags +genpts -i "$filename" -c:v libx264 -c:a copy -map 0:v:0 -map 0:a:0 "$basepath.mkv"
	else
		for f in **/*.avi; do
			[ -f "$f" ] || continue
			convert_mkv "$f"
		done
	fi
}

merge_bin() {
        output=$1
	if [ "$#" -eq 2 ]
	then
		game=$2
		echo "Merging $game bins to $output/$game"
                mkdir -p "$output/$game"
                for cue in "$game"/*.cue; do
                        basename=${cue:t:r}
                        echo "  $basename"
			/Users/hammer/SoftwareDevelopment/OpenSource/binmerge/binmerge -o "$output/$game" "$cue" "$basename"

                       png_path="/Users/hammer/SoftwareDevelopment/OpenSource/libretro-thumbnails/Sony - PlayStation/Named_Boxarts/$basename.png"
                       if [ -f "$png_path" ]
                       then
                          echo "Converting cover to jpeg"
                          sips --setProperty format jpeg "$png_path" --out "$output/$game/$basename.jpg"
                       fi
		done
	else
		for d in *; do
			[ -d "$d" ] || continue
			merge_bin $output "$d"
		done
	fi
}

cue_to_iso() {
	if [ "$#" -eq 1 ]
	then
		game=$1
		echo "Converting $game to $output/$game.iso"
                for cue in "$game"/*.cue; do
                        basename=${cue:t:r}
                        bin=${cue:r}.bin
			bchunk "$bin" "$cue" "$basename"
		done
	else
		for d in *; do
			[ -d "$d" ] || continue
			cue_to_iso "$d"
		done
	fi
}



# MySQL
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# ==============================================================================
# Claude Code Integration Helpers
# ==============================================================================
# Add Claude bin to PATH for ide, ide-dashboard, ide-switcher commands
export PATH="$HOME/.claude/bin:$PATH"

# Load helper functions for AWS, Jira, Confluence, Slack, Sentry, Datadog, etc.
# See ~/.claude/INTEGRATIONS.md for available functions
#if [ -f ~/.claude/lib/integrations.sh ]; then
#    source ~/.claude/lib/integrations.sh
#fi

# Claude Session starter - creates/attaches tmux session and starts Claude CLI
cs() {
    local session_name="${1:-claude}"
    local session_type="${2:-launcher}"  # Default to launcher for minimal startup in tmux

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach -t "$session_name"
    else
        # Create new session in ~/.claude with claude
        tmux new-session -d -s "$session_name" -c "$HOME/.claude" "claude"

        # Set base-index to 0 for this session and move window to index 0
        tmux set-option -t "$session_name" base-index 0
        tmux move-window -s "$session_name" -t 0

        # Wait for claude to initialize
        sleep 2

        # Send /start command (remove :0 - just target the session)
        tmux send-keys -t "$session_name" "/start $session_type"

        # Small delay, then send Enter separately
        sleep 0.3
        tmux send-keys -t "$session_name" C-m

        # Attach to the session
        tmux attach -t "$session_name"
    fi
}

# Claude Tab - opens new Claude instance in a new tmux window
ct() {
    if [[ -z "$TMUX" ]]; then
        echo "Error: ct requires tmux. Use 'cs' to start a tmux session first."
        return 1
    fi

    # Load tmux helpers if not already loaded (silently)
    if ! type tmux_new_window &>/dev/null; then
        source ~/.claude/lib/core/loader.sh &>/dev/null
    fi

    local session_type="$1"
    local window_name=""

    # Map session type to window name with emoji
    if [[ -n "$session_type" ]]; then
        case "$session_type" in
            coding)     window_name="💻 coding" ;;
            debugging)  window_name="🐛 debug" ;;
            analysis)   window_name="🔍 analysis" ;;
            planning)   window_name="📋 planning" ;;
            presenting) window_name="📊 presenting" ;;
            learning)   window_name="📚 learning" ;;
            personal)   window_name="🏠 personal" ;;
            clauding)   window_name="🔧 clauding" ;;
            *)          window_name="$session_type" ;;
        esac
    fi

    # Create new window with claude
    if [[ -n "$window_name" ]]; then
        tmux_new_window "$window_name" "claude"
        if [[ $? -eq 0 && -n "$session_type" ]]; then
            # Wait for claude to initialize
            sleep 2

            # Send /start command to the new window (text first)
            tmux send-keys "/start $session_type"

            # Small delay, then send Enter separately
            sleep 0.3
            tmux send-keys C-m

            echo "✓ Opened: $window_name (starting $session_type session)"
        else
            echo "✓ Opened: $window_name"
        fi
    else
        tmux_new_window "" "claude" && echo "✓ Opened new Claude window"
    fi
}

# ==============================================================================
# PATH Final Configuration
# ==============================================================================
# Ensure ~/bin comes first to allow wrapper scripts to shadow system commands
# This must be at the end after NVM, Herd, and other tools modify PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Load Claude agent aliases (e.g., alexandria, cody, debbie, etc.)
eval "$(~/.claude/agents/sync-aliases.sh)"

# bun completions
[ -s "/Users/hammer/.bun/_bun" ] && source "/Users/hammer/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# (Herd-injected PATH and HERD_PHP_*_INI_SCAN_DIR exports removed —
# Herd was uninstalled in favor of Docker-based local stack.)

# ==============================================================================
# Local / per-machine overrides — gitignored, holds secrets and host-specific bits
# ==============================================================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
