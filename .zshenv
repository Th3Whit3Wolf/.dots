typeset -U PATH path

if [ -x "/usr/bin/go" ]; then
	export GOPATH="$HOME/.go"
fi

if [ -x "/usr/bin/npm" ]; then
	export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/.npm/npmrc"
    node_modules="$PATH:$HOME/.node_modules/bin:$PAH"
	export npm_config_prefix=~/.node_modules
fi

if [ -x "usr/bin/cabal" ]; then
	cabal="$HOME/.cabal/bin"
fi

if [ -x "opt/dart-sdk/bin/dart" ]; then
	dart="$HOME/.pub/bin"
fi

path=("$HOME/.local/bin" "$GOPATH" "$node_modules" "$dart" "$cabal" "$HOME/.cargo/bin" "$path[@]")
export PATH
export npm_config_prefix=~/.node_modules

# Colorful Man Pages
export PAGER=less
export LESS_TERMCAP_mb=$'\E[01;31m'         # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'    # begin bold
export LESS_TERMCAP_me=$'\E[0m'             # end mode
export LESS_TERMCAP_se=$'\E[0m'             # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'      # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'             # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m'   # begin underline

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR=nvim
export VISUAL=code-oss
export GTK_USE_PORTAL=1
