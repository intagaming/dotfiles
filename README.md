# dotfiles

## Installation

1. Download 1Password, setup SSH.

2. Run:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --ssh --apply intagaming
```

3. Here's things to do:

- Install `fish starship node neovim ripgrep fzf`
- Configure `nvm.fish`
- 1Password SSH WSL setup:
  - In Windows:
    [`npiperelay.exe`](https://github.com/jstarks/npiperelay/releases)
  - In WSL: `sudo apt install socat`

If WSL doesn't recognize 1Password SSH, run:

```bash
ps -x | grep EXEC:[n]piperelay | awk '{print $1}' | xargs kill -9
```
