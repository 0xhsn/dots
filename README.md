# dots

> Give me six hours to chop down a tree, and I will spend the first four sharpening the axe.

## Installation

Bootstrap with `brew` or the `install.sh` script, setup with `chezmoi`

```shell
# macOS specific
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# init
chezmoi init rubyroobs/dots

# change shell to zsh if not already default
chsh -s $(which zsh)
```

## Components

- `.tmux.conf`: Terminal multiplexer configuration
- `.vimrc` & `.vim/`: Vim editor configuration and plugins
- `.zshrc`: Zsh shell configuration
- `git/config`: Git configuration with aliases and signing setup
- `starship.toml`: Cross-shell prompt configuration
- `.ssh/`: SSH configuration with 1Password integration
  - Uses 1Password SSH agent for key management
  - Includes connection keepalive settings
  - OrbStack integration for container/VM access

## Structure

The repository follows chezmoi's conventions:

```
home/
├── dot_tmux.conf              # → ~/.tmux.conf
├── dot_vim/                  # → ~/.vim/
├── dot_vimrc                # → ~/.vimrc
├── dot_zshrc                # → ~/.zshrc
├── dot_ssh/                 # → ~/.ssh/
│   └── config              # → ~/.ssh/config
└── private_dot_config/
    ├── git/
    │   └── config          # → ~/.config/git/config
    └── starship.toml      # → ~/.config/starship.toml
```

## Post-installation

After installation, you may want to:

1. Install Vim plugins (if any are configured)
2. Install Tmux plugin manager (if using plugins)
3. Install Starship prompt if not already installed:
   ```shell
   curl -sS https://starship.rs/install.sh | sh
   ```
4. Set up GPG for Git commit signing:
   ```shell
   # Import your GPG key if needed
   gpg --import your-key.asc
   ```
5. Configure 1Password SSH agent:
   - Enable SSH agent in 1Password settings
   - Add your SSH keys to 1Password
   - They will be automatically available through the SSH agent

## Maintenance

To update your dotfiles:

```shell
chezmoi update
```

To add new dotfiles:

```shell
chezmoi add ~/.file
```