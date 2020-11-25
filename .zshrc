# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

if [[ -d ~/.shell/scripts ]]; then
    fpath=(~/.shell/scripts $fpath)
    for function_file in ~/.shell/scripts/*
    do
        autoload -Uz ${function_file##*/}
    done
    unset function_file
	autoload -Uz compinit
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search add-zsh-hook
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

zshcache_time="$(date +%s%N)"
rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

reset_broken_terminal () {
	printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}

command_not_found_handler() {
	local pkgs cmd="$1" files=()
	printf 'zsh: command not found: %s' "$cmd" # print command not found asap, then search for packages
	files=(${(f)"$(pacman -F --machinereadable -- "/usr/bin/${cmd}")"})
	if (( ${#files[@]} )); then
		printf '\r%s may be found in the following packages:\n' "$cmd"
		local res=() repo package version file
		for file in "$files[@]"; do
			res=("${(0)file}")
			repo="$res[1]"
			package="$res[2]"
			version="$res[3]"
			file="$res[4]"
			printf '  %s/%s %s: /%s\n' "$repo" "$package" "$version" "$file"
		done
	else
		printf '\n'
	fi
	return 127
}

add-zsh-hook -Uz precmd rehash_precmd
add-zsh-hook -Uz precmd reset_broken_terminal

for dump in ~/.zcompdump(N.mh+24); do
	compinit
done
compinit -C

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate
# select completions with arrow keys
zstyle ':completion:*' menu select
# group results by category
zstyle ':completion:*' group-name ''
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
# enabling autocompletion of privileged environments in privileged commands
#zstyle ':completion::complete:*' gain-privileges 1
#zstyle ':urlglobber' url-other-schema

# Source alliases, exports, etc
[[ -f ~/.shell/aliasrc ]] && . ~/.shell/aliasrc
[[ -f ~/.shell/distro ]] && . ~/.shell/distro
[[ -f ~/.shell/misc ]] && . ~/.shell/misc
[[ -f ~/.shell/sys ]] && . ~/.shell/sys
[[ -f ~/.shell/typos ]] && . ~/.shell/typos
[[ -f ~/.zsh_plugins.sh ]] && . ~/.zsh_plugins.sh
[[ -f /opt/git/git-subrepo/.rc ]] && . /opt/git/git-subrepo/.rc
zmodload -i zsh/complist

################################################
#                 KEYBINDINGS                  #
################################################
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -- "${key[Insert]}"        overwrite-mode
[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"     backward-delete-char
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-beginning-search
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-beginning-search
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"          backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"         forward-char
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"        beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"      end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}"     ]] && bindkey -- "${key[Shift-Tab]}"     reverse-menu-complete
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

################################################
#                    ALIASES                   #
################################################
alias ali='alias | bat --style=numbers,grid -l cpp'
alias antibupdate='antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh'
################################################
#                 ENVIRONMENT                  #
################################################
setopt always_to_end        # move cursor to end if word had one match
#setopt auto_cd              # cd by typing directory name if it's not a command
setopt auto_list            # automatically list choices on ambiguous completion
setopt auto_menu            # automatically use menu completion
setopt correct_all          # autocorrect commands

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

unsetopt nomatch

setopt append_history
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks   # remove superfluous blanks from history items
setopt inc_append_history   # save history entries as soon as they are entered
setopt share_history        # share history between different instances
setopt correct_all          # autocorrect commands
setopt interactive_comments # allow comments in interactive shells
setopt complete_aliases

stty icrnl

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
