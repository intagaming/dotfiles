if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

    # Run only for MacOS
    if test uname = "Darwin"
        # Run 'code' to open VSCode
        fish_add_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        fish_add_path "~/Library/Python/3.8/bin"
    end

    fish_add_path "~/.cargo/bin"
    fish_add_path "~/.local/bin"
end
