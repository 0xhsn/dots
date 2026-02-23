#!/bin/sh
# 1Password CLI helper functions for machine bootstrapping
#
# Usage:
#   1. Sign into 1Password CLI: eval $(op signin)
#   2. Inject secrets from templates:
#        op_update_secret_from_template ~/.config/gh/hosts.yml
#   3. (Future) Download YubiKey SSH stubs:
#        op_download_ssh_key 5C_NFC_001_t100

# Inject secrets from a .tpl template file into the target config.
# Template files use op:// references that 1Password resolves at runtime.
# Safe to commit .tpl files — they're just pointers, not secrets.
op_update_secret_from_template() {
    local target="$1"
    local template="${target}.tpl"

    if [ ! -f "$template" ]; then
        echo "error: no template found at $template" >&2
        return 1
    fi

    mkdir -p "$(dirname "$target")"
    op inject -i "$template" -o "$target" -f
    chmod 600 "$target"
    echo "injected: $target"
}

# Download SSH public key stub from 1Password for a YubiKey handle.
# The handle is the 1Password item name (e.g. "5C_NFC_001_t100").
# SSH needs these stubs to know which hardware key to request.
#
# TODO: Not yet active — waiting on YubiKey 5C NFC purchase.
#       Once you have YubiKeys:
#       1. Generate FIDO2 resident keys: ssh-keygen -t ed25519-sk -O resident
#       2. Store the public key stub in 1Password as an SSH Key item
#       3. Name the item with your convention: <model>_<serial>_<alias>
#       4. Run: op_download_ssh_key <handle>
op_download_ssh_key() {
    local handle="$1"

    if [ -z "$handle" ]; then
        echo "usage: op_download_ssh_key <yubikey_handle>" >&2
        return 1
    fi

    op item get "$handle" --fields "public key" > "$HOME/.ssh/${handle}.pub"
    chmod 644 "$HOME/.ssh/${handle}.pub"
    echo "downloaded: ~/.ssh/${handle}.pub"
}
