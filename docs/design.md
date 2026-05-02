# Dotfiles Design Document

## Overview

This repository manages personal dotfiles across multiple machines and operating systems using symlinks, git, and shell-integrated update notifications. The goal is a simple, low-friction setup: clone once, run install, and all config files are live immediately. Updates propagate automatically via a synchronous git fetch (with timeout) and an interactive prompt on shell start.

Supported platforms: macOS and Linux (including WSL).

---

## Design Decisions

### Symlink-based

Files live in the repository and are symlinked to their expected locations in the home directory. Editing a config file in place immediately changes the repo working tree — no copy or template step is needed. This makes the feedback loop instant and keeps `git diff` always accurate.

### Single file with OS conditionals

Rather than maintaining OS-specific overlay files or separate branches, all platform branching happens inside individual config files using inline conditionals:

```zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS-specific config
fi
```

This keeps related configuration together and avoids the cognitive overhead of tracking which overlay applies where. macOS-only sections (Java/Homebrew JDK, Android SDK paths) are wrapped in `OSTYPE` guards. Cross-platform sections (Android SDK) use OS-conditional paths with existence checks.

### Symlink everything regardless of installed tools

The install script creates all symlinks unconditionally, even for tools not installed on the current machine. A dangling symlink causes no harm, and the tool works immediately when later installed without re-running the install script. Tool existence checks (e.g., `command -v nvim`) belong inside config files, not in the install script.

### Interactive install with backup

When the install script encounters an existing file at a symlink target, it prompts for confirmation before overwriting. Existing files are backed up with a timestamp suffix before being replaced:

```
~/.zshrc  ->  ~/.zshrc.backup.20260404-153012
```

The timestamp includes hours/minutes/seconds to prevent backup collisions when running `install.sh` multiple times on the same day.

### Synchronous update check with timeout

`git fetch origin` runs synchronously at shell startup with a 3-second timeout using `perl -e 'alarm(3); exec @ARGV'`. This avoids background job notifications (e.g., `[3] 40017`) and shows the update prompt immediately rather than requiring a keypress. The `perl alarm()` approach is portable across all supported platforms (macOS, Linux, WSL, Cygwin) without requiring additional tools like `timeout` or `gtimeout`. If the network is slow, the fetch times out after 3 seconds and the shell starts normally. The update check logic is extracted to `shell/update-check.zsh`.

### Eagerly-loaded nvm

`nvm.sh` is sourced eagerly at shell startup. A lazy-loaded variant was tried previously but had correctness issues (stub functions did not always hand off cleanly to the real `nvm`, and `node`/`npm` PATH resolution diverged from `nvm` state), so the setup was reverted to the standard eager load. The `.zshrc` tries OS-specific locations in order: Homebrew (`/opt/homebrew` → `/usr/local`) on macOS, then `$NVM_DIR/nvm.sh` as a fallback.

This adds ~360ms to cold shell startup. Revisit lazy-loading if startup latency becomes a priority.

### Modular shell config

Heavy or logically distinct sections of `.zshrc` are extracted to separate files under `shell/` and sourced from `.zshrc`. This keeps the main config readable and makes individual features easier to maintain. Current modules:

- `shell/git.zsh` — Git helper functions (tag push/delete, tag sync)
- `shell/sdkman.zsh` — SDKMAN (JVM SDK manager) init, guarded per-machine
- `shell/mise.zsh` — mise (polyglot runtime version manager) init, guarded per-machine
- `shell/update-check.zsh` — Dotfiles update notification

### Runtime version manager init order

When more than one runtime version manager is installed on the same machine (e.g. `nvm` and `mise`, or `rbenv` and `mise`), each one's activation prepends its shim or bin directory to `PATH`. The one initialized **last** wins, because its entries end up first in the lookup order.

`shell/.zshrc` initializes them in this order:

1. `sdkman` — only manages JVM tooling (`java`, `gradle`, …). No overlap with other managers, so its position does not matter.
2. `rbenv` — prepends `~/.rbenv/shims`.
3. `nvm` — prepends `$NVM_DIR/versions/node/<version>/bin`.
4. `mise` — sourced from the bottom of `.zshrc`, after every other PATH-mutating block (including `$HOME/.local/bin`, OpenClaw completions, and the managers above).

`mise` is intended to be the unified replacement for the older single-language managers, so it must come last on machines where both are still installed: that way `.tool-versions` resolution wins over a stale `nvm`/`rbenv` shim. If `mise` is not installed, `shell/mise.zsh` is a no-op and the older managers continue to work as before.

### No package management

This repository manages config files only. Tool installation is intentionally out of scope. Each machine may have a different set of tools installed, and coupling config management to package installation would add complexity without proportional benefit.

### Powerlevel10k config as fallback only

`p10k configure` generates machine-specific output based on terminal capabilities (fonts, unicode, colors). Rather than symlinking a shared config, the dotfiles repo stores a default at `shell/p10k.default.zsh`. The `.zshrc` loads `~/.p10k.zsh` if it exists (machine-local), otherwise falls back to the dotfiles default. This means new machines get a working prompt immediately, while existing machines keep their own configuration untouched.

### Git config partially excluded

`~/.gitconfig` is not managed by this repository because it typically contains machine-specific values such as credential helpers and user identity. Only `~/.config/git/ignore` (the global gitignore) is managed, as it contains patterns that apply universally.

---

## Symlink Mapping

| Repo Path | Target | Type |
|---|---|---|
| `shell/.zshrc` | `~/.zshrc` | file |
| `vim/.vimrc` | `~/.vimrc` | file |
| `config/nvim` | `~/.config/nvim` | directory |
| `config/zellij` | `~/.config/zellij` | directory |
| `config/kitty` | `~/.config/kitty` | directory |
| `config/git` | `~/.config/git` | directory |

Directory symlinks are used for tool configs under `~/.config/` to keep the symlink count manageable and to ensure new files added inside those directories are automatically tracked without updating the install script.

---

## Update Notification Flow

1. Shell starts. `git fetch origin` runs synchronously with a 3-second timeout.
2. Local HEAD is compared against remote HEAD.
3. If local is behind remote, the shell prints a notification and prompts:
   ```
   Updates available. Apply now? [Y/n]:
   ```
4. Enter or `y`: runs `dotfiles sync`, which pulls the latest commits and re-runs `install.sh` to apply any new symlinks.
5. `n`: skips the update.

### CLI Safety Guards

- `dotfiles sync` checks for uncommitted changes before running `git pull --rebase`. If the working tree is dirty, it aborts with a warning.
- `dotfiles push` shows pending changes and asks for confirmation before staging with `git add -A`. This prevents accidentally committing unintended files.

---

## Future Considerations

- **Common git config**: Add `~/.config/git/config` to the repo for shared settings such as `user.name`, commit signing preferences, and aliases. Machine-specific values (credential helpers, `user.email`) would remain in the unmanaged `~/.gitconfig`.
- **Package list management**: Optionally track a Homebrew `Brewfile` or apt package list for reproducible machine setup, separate from the dotfiles install flow.
- **Machine-specific overrides**: A sourced local config file (e.g., `~/.zshrc.local`, gitignored) could provide per-machine overrides without requiring repo changes.
- **Secret management**: Sensitive values could be handled via encrypted files (e.g., git-crypt) or a separate private repository, keeping this repo fully public-safe.
