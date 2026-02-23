#!/bin/bash
set -e

OS="$(uname -s)"

echo "Setting up dotfiles for $OS..."

# Install chezmoi
if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi..."
    if [ "$OS" = "Darwin" ]; then
        brew install chezmoi
    else
        sh -c "$(curl -fsLS get.chezmoi.io)"
    fi
fi

# macOS setup
if [ "$OS" = "Darwin" ]; then
    # Install Homebrew if missing
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages from Brewfile
    if [ -f "$(dirname "$0")/../Brewfile" ]; then
        brew bundle --file="$(dirname "$0")/../Brewfile"
    fi

    # Install starship
    if ! command -v starship &>/dev/null; then
        brew install starship
    fi
fi

# Ubuntu/Linux setup
if [ "$OS" = "Linux" ]; then
    sudo apt update && sudo apt install -y \
        git curl wget zsh tmux neovim jq btop \
        build-essential libssl-dev

    # Install starship
    if ! command -v starship &>/dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Install mise
    if ! command -v mise &>/dev/null; then
        curl https://mise.run | sh
    fi

    # Install WhiteSur cursors
    if [ ! -d "$HOME/.icons/WhiteSur-cursors" ]; then
        echo "Installing WhiteSur cursors..."
        TMPDIR=$(mktemp -d)
        git clone https://github.com/vinceliuice/WhiteSur-cursors.git "$TMPDIR"
        cd "$TMPDIR" && ./install.sh
        rm -rf "$TMPDIR"
    fi
fi

# Apply dotfiles
chezmoi init 0xhsn/dots
chezmoi apply

# Change shell to zsh if needed
if [ "$SHELL" != "$(which zsh)" ] && command -v zsh &>/dev/null; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

echo "Done. Restart your shell or run: exec zsh"
