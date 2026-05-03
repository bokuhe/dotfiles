# dotfiles

Personal shell and editor configuration managed as symlinks from a central repository.

## Quick Start

```sh
git clone https://github.com/bokuhe/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Directory Structure

```
~/dotfiles/
├── install.sh              # Interactive symlink installer with backup
├── shell/.zshrc            # Zsh config (oh-my-zsh, powerlevel10k, plugins)
├── shell/p10k.default.zsh  # Powerlevel10k default config (fallback)
├── shell/git.zsh           # Git helper functions (tag, sync-tags)
├── shell/sdkman.zsh        # SDKMAN init (opt-in per machine)
├── shell/mise.zsh          # mise init (opt-in per machine)
├── shell/update-check.zsh  # Dotfiles update notification on shell startup
├── vim/.vimrc              # Vim config
├── config/nvim/init.vim    # Neovim config (sources .vimrc)
├── config/zellij/config.kdl # Zellij terminal multiplexer config
├── config/kitty/kitty.conf # Kitty terminal emulator config
├── config/git/ignore       # Global gitignore
├── bin/dotfiles            # CLI tool (sync, push, status, edit, help)
└── docs/
    ├── design.md           # Design decisions
    └── plans/              # Implementation plans
```

## Symlink Mappings

| Repo path          | Home directory target  |
|--------------------|------------------------|
| shell/.zshrc       | ~/.zshrc               |
| vim/.vimrc         | ~/.vimrc               |
| config/nvim        | ~/.config/nvim         |
| config/zellij      | ~/.config/zellij       |
| config/kitty       | ~/.config/kitty        |
| config/git         | ~/.config/git          |

## CLI Commands

The `bin/dotfiles` tool provides shortcuts for common operations. The `.zshrc` automatically adds `~/dotfiles/bin` to `PATH`.

| Command          | Description                                              |
|------------------|----------------------------------------------------------|
| dotfiles sync    | Pull latest changes and re-apply symlinks (checks for uncommitted changes first) |
| dotfiles push    | Show changes, confirm staging, commit, and push          |
| dotfiles status  | Show local changes and ahead/behind remote count         |
| dotfiles edit    | Open the dotfiles directory in your editor               |
| dotfiles help    | Print available commands                                 |

## Update Notifications

On shell startup, `.zshrc` sources `shell/update-check.zsh` which runs a synchronous `git fetch` with a 3-second timeout (via `perl alarm()`, portable across all platforms). It then compares local and remote HEAD. If updates are available, you will see a prompt:

```
[dotfiles] Updates available (3 commit(s) behind).
Apply now? [Y/n]:
```

Enter or `y` runs `dotfiles sync`; `n` skips the update.

## Supported Platforms

- macOS (Intel and Apple Silicon)
- WSL (Windows Subsystem for Linux)
- Linux: Ubuntu, Fedora

## install.sh Behavior

The installer creates symlinks for each entry in the mappings table. If a file or directory already exists at the target path, you are prompted to overwrite it. Existing files are backed up with a timestamp suffix (e.g., `.zshrc.backup.20260404-153012`) before the symlink is created.

## Powerlevel10k

The repository includes `shell/p10k.default.zsh` as a fallback configuration. `.zshrc` prefers `~/.p10k.zsh` (machine-local) over the default, so:

- **New machines** get a working prompt with the bundled default — no setup needed.
- **Per-machine theme override**: place a custom config at `~/.p10k.zsh` (run `p10k configure` or copy a config you like). The repo file stays untouched; only this machine sees the override.

### Pitfall: `p10k configure` may modify the repo

If `~/.p10k.zsh` does not exist when you run `p10k configure`, the wizard follows the source path it finds in `.zshrc` and may overwrite `shell/p10k.default.zsh` directly — polluting `dotfiles sync`, which refuses to run on a dirty tree. Recover by moving your customization out and reverting the repo file:

```sh
cp shell/p10k.default.zsh ~/.p10k.zsh
git checkout -- shell/p10k.default.zsh
```

After this, future `p10k configure` runs will edit `~/.p10k.zsh` directly without touching the repo.

## Editing Configuration

Since all config files are symlinked, editing them in their usual location (e.g., `~/.zshrc`) directly modifies the repo. To push changes to other machines:

```sh
dotfiles push
```

Other machines will see an update notification on next shell startup.
