# Secrets & SSH Keys

Secrets are managed through **1Password CLI** — no credentials are stored in this repo. Template files (`.tpl`) contain `op://` references that get resolved at runtime.

## How it works

```
┌─────────────────┐     op inject     ┌─────────────────┐
│ hosts.yml.tpl   │ ───────────────→  │ hosts.yml        │
│ (in git, safe)  │   1Password CLI   │ (local, secret)  │
│ op://Personal/… │                   │ ghp_abc123...    │
└─────────────────┘                   └─────────────────┘
```

Template files use `op://vault/item/field` pointers. These are safe to commit — they're useless without 1Password authentication.

## Bootstrap secrets on a new machine

```shell
# 1. Sign into 1Password CLI
eval $(op signin)

# 2. Inject secrets from templates
op_update_secret_from_template ~/.config/gh/hosts.yml
```

## Available templates

| Template | Target | What it provides |
|----------|--------|-----------------|
| `gh/hosts.yml.tpl` | `~/.config/gh/hosts.yml` | GitHub CLI authentication |

## YubiKey SSH keys (future)

When using YubiKeys with FIDO2 resident keys, SSH needs public key stubs on disk to know which hardware key to request. 1Password acts as the inventory — it stores the stubs alongside metadata about which YubiKey holds which key.

```
┌──────────┐              ┌──────────────┐           ┌─────────┐
│ 1Password│  stub file   │   ~/.ssh/    │  SSH auth │ YubiKey │
│ (inventory)│ ──────────→ │ 5C_NFC_001_t100.pub  │ ────────→ │ (touch) │
└──────────┘  op_download │              │           └─────────┘
              _ssh_key    └──────────────┘
```

### Why both 1Password and YubiKey?

- **1Password** — holds all secrets (API keys, tokens, passwords) and acts as the SSH agent for day-to-day use. Software vault, cloud-synced.
- **YubiKey** — hardware key storage. Private keys are burned into the chip, can't be extracted even if 1Password is compromised. Physical tap required per operation.

They're complementary: 1Password for convenience and secret management, YubiKey for keys that must survive a full account compromise. You don't need YubiKeys if you trust 1Password's security — it's an upgrade path.

### Setup (once you have YubiKeys)

```shell
# 1. Generate a FIDO2 resident key on the YubiKey
ssh-keygen -t ed25519-sk -O resident -C "5C_NFC_001_t100"

# 2. Store the public key stub in 1Password as an SSH Key item
#    Name it with your convention: <model>_<serial>_<alias>

# 3. On any new machine, download the stubs
op_download_ssh_key 5C_NFC_001_t100
```

### Recommended hardware

**YubiKey 5C NFC** (~$55) — USB-C for Mac, NFC for phone. Buy two and register both everywhere as backup.
