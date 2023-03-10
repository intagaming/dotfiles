if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source

    # Run 'code' to open VSCode
    fish_add_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

    # Android Setup
    set ANDROID_HOME /Users/an7/Library/Android/sdk
    fish_add_path "/Users/an7/Library/Android/sdk/platform-tools"
    set ANDROID_SDK_ROOT /Users/an7/Library/Android/sdk

    fish_add_path "/Users/an7/.cargo/bin"
    fish_add_path "/Users/an7/Library/Python/3.8/bin"

    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
end
