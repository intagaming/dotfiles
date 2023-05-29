set -gx MOZ_ENABLE_WAYLAND 1

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

    fish_add_path "$HOME/.cargo/bin"
    fish_add_path "$HOME/.local/bin"

    # Deno
    set DENO_INSTALL "/home/an7/.deno"
    fish_add_path "$DENO_INSTALL/bin"

    set EDITOR "/usr/local/bin/nvim"
    set GIT_EDITOR "/usr/local/bin/nvim"

    set SSH_AUTH_SOCK ~/.1password/agent.sock

    fish_add_path "/usr/local/go/bin"
end
