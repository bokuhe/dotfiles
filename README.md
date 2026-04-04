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
├── vim/.vimrc              # Vim config
├── config/nvim/init.vim    # Neovim config (sources .vimrc)
├── config/zellij/config.kdl # Zellij terminal multiplexer config
├── config/git/ignore       # Global gitignore
├── assets/avatar.jpg       # Profile avatar
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

On shell startup, `.zshrc` runs `git fetch` in the background (non-blocking). Once the fetch completes, a `precmd` hook compares local and remote HEAD. If updates are available, you will see a prompt:

```
[dotfiles] Updates available (3 commit(s) behind).
Apply now? [Y/n]:
```

Enter or `y` runs `dotfiles sync`; `n` defers until the next session. The check runs at most once per session.

## Supported Platforms

- macOS (Intel and Apple Silicon)
- WSL (Windows Subsystem for Linux)
- Linux: Ubuntu, Fedora

## install.sh Behavior

The installer creates symlinks for each entry in the mappings table. If a file or directory already exists at the target path, you are prompted to overwrite it. Existing files are backed up with a timestamp suffix (e.g., `.zshrc.backup.20260404-153012`) before the symlink is created.

## Powerlevel10k

The repository includes `shell/p10k.default.zsh` as a fallback configuration. If `~/.p10k.zsh` exists on the machine (from running `p10k configure`), it takes priority. If not, the dotfiles default is used. This means new machines get a working prompt immediately without running `p10k configure`.

## Editing Configuration

Since all config files are symlinked, editing them in their usual location (e.g., `~/.zshrc`) directly modifies the repo. To push changes to other machines:

```sh
dotfiles push
```

Other machines will see an update notification on next shell startup.
