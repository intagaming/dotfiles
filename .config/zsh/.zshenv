export TERMINAL="st"
export EDITOR="nvim"

# export PATH="$PATH:${$(find ${HOME}/.local/bin -type d -printf %p:)%%:}"
export PATH="$PATH:$HOME/.local/bin"
# Later maybe use stow for these things
export PATH="$PATH:$HOME/.local/bin/statusbar"

# FPT University proxy
# source $HOME/fpt/proxyon.sh

# Let JetBrains IDE use their jdk
export IDEA_JDK=/usr/lib/jvm/jdk-jetbrains

# fix for JetBrains IDEs and such java
export _JAVA_AWT_WM_NONREPARENTING=1

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export XIM_PROGRAM=/usr/bin/ibus-daemon

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
