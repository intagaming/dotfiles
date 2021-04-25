# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set command history file
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="$HOME/.zsh_history"

# powerlevel10k theme (install with package manager like yay)
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# zsh completion system
autoload -Uz compinit && compinit -i

# zsh-vi-mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
# fzf-tab
source ~/.local/share/fzf-tab/fzf-tab.plugin.zsh
# zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# aliases
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# fzf
# Prevent zsh-vi-mode from overriding Ctrl+R fzf
zvm_after_init_commands+=('[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh')
source /usr/share/fzf/completion.zsh


# zsh-autosuggestions color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245'

# nnn quitcd (run cd on quit), with -e (external text editor)
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    /usr/bin/nnn -e "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# docker-compose zsh completion thingy
fpath=(~/.config/zsh/completion $fpath)

# powerlevel10k start
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
