# dots

> Give me six hours to chop down a tree, and I will spend the first four sharpening the axe.

## Quick start

```shell
git clone https://github.com/0xhsn/dots.git
cd dots && ./scripts/setup.sh
```

Or manually:

```shell
# macOS
brew install chezmoi
chezmoi init 0xhsn/dots --apply

# Ubuntu
sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init 0xhsn/dots --apply
```

## Components

- `.zshrc` — shell config, aliases, mise, starship
- `.tmux.conf` — backtick prefix, Catppuccin theme
- `.vimrc` & `.vim/` — Vim with photon colorscheme
- `nvim/init.lua` — Neovim with lazy.nvim + Catppuccin
- `zed/settings.json` — Zed editor config
- `git/config` — Git aliases, SSH signing via 1Password
- `starship.toml` — cross-shell prompt
- `.ssh/config` — SSH with 1Password agent (macOS), keepalive

## Structure

```
home/
├── .chezmoi.toml.tmpl          → ~/.config/chezmoi/chezmoi.toml
├── dot_tmux.conf               → ~/.tmux.conf
├── dot_vim/                    → ~/.vim/
├── dot_vimrc                   → ~/.vimrc
├── dot_zshrc                   → ~/.zshrc
├── private_dot_ssh/
│   └── config.tmpl             → ~/.ssh/config
└── private_dot_config/
    ├── gh/hosts.yml.tpl        — 1Password template for GitHub CLI
    ├── git/config              → ~/.config/git/config
    ├── nvim/init.lua           → ~/.config/nvim/init.lua
    ├── shell/op-functions.sh   → ~/.config/shell/op-functions.sh
    ├── starship.toml           → ~/.config/starship.toml
    └── zed/settings.json       → ~/.config/zed/settings.json
scripts/
└── setup.sh                    — bootstrap for macOS & Ubuntu
Brewfile                        — macOS packages
```

## Cross-platform

Chezmoi templates handle OS differences:
- **macOS** — 1Password SSH agent, `op-ssh-sign` for git, OrbStack, Homebrew
- **Ubuntu** — WhiteSur cursors, standard ssh-agent, mise via curl

## Secrets & SSH keys

See [docs/secrets.md](docs/secrets.md) for the full 1Password + YubiKey setup.

## Maintenance

```shell
chezmoi update          # pull & apply latest
chezmoi re-add          # sync local changes back to repo
chezmoi diff            # see what would change
```
