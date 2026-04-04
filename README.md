# dotfiles

Personal shell and editor configuration managed as symlinks from a central repository.

## Quick Start

```sh
git clone https://github.com/erython/dotfiles.git ~/dotfiles
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

The `bin/dotfiles` tool provides shortcuts for common operations. Add `~/dotfiles/bin` to your `PATH` to use it.

| Command          | Description                                      |
|------------------|--------------------------------------------------|
| dotfiles sync    | Pull latest changes and re-apply symlinks        |
| dotfiles push    | Stage, commit, and push local changes            |
| dotfiles status  | Show git status of the dotfiles repository       |
| dotfiles edit    | Open the dotfiles directory in your editor       |
| dotfiles help    | Print available commands                         |

## Update Notifications

On shell startup, `.zshrc` silently checks for new commits on the remote. If updates are available, you will see a prompt offering to apply them. Accepting runs `dotfiles sync`; declining defers until the next session.

## Supported Platforms

- macOS (Intel and Apple Silicon)
- WSL (Windows Subsystem for Linux)
- Linux: Ubuntu, Fedora

## install.sh Behavior

The installer creates symlinks for each entry in the mappings table. If a file or directory already exists at the target path, you are prompted to overwrite it. Existing files are backed up with a date suffix (e.g., `.zshrc.backup.20260404`) before the symlink is created.
