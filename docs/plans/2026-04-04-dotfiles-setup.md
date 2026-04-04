# Dotfiles Management System - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a cross-platform dotfiles management system with symlink-based sync, interactive install, and shell-integrated update notifications.

**Architecture:** Git repo at `~/dotfiles` with config files organized by category. `install.sh` creates symlinks to home directory. `bin/dotfiles` CLI provides sync/push/status commands. `.zshrc` includes background fetch + interactive update prompt on shell start.

**Tech Stack:** Bash/Zsh scripts, Git, symlinks

**Target platforms:** macOS (Intel/Apple Silicon), WSL, Linux (Ubuntu, Fedora)

---

### Task 1: Directory Structure and Config Files

**Files:**
- Create: `shell/.zshrc` (copy from assets repo)
- Create: `shell/.p10k.zsh` (copy from `~/.p10k.zsh`)
- Create: `vim/.vimrc` (copy from assets repo)
- Create: `config/nvim/init.vim` (copy from assets repo)
- Create: `config/zellij/config.kdl` (copy from `~/.config/zellij/config.kdl`)
- Create: `config/git/ignore` (new global gitignore)
- Create: `assets/avatar.jpg` (copy from assets repo)

**Step 1: Create directory structure**

```bash
cd ~/dotfiles
mkdir -p shell vim config/nvim config/zellij config/git assets bin docs
```

**Step 2: Copy config files from assets repo and current system**

```bash
cp ~/works/private/assets/private/rc/.zshrc shell/.zshrc
cp ~/.p10k.zsh shell/.p10k.zsh
cp ~/works/private/assets/private/rc/.vimrc vim/.vimrc
cp ~/works/private/assets/private/rc/nvim/init.vim config/nvim/init.vim
cp ~/.config/zellij/config.kdl config/zellij/config.kdl
cp ~/works/private/assets/private/avatar.jpg assets/avatar.jpg
```

**Step 3: Create `config/git/ignore`**

```
# OS
.DS_Store
Thumbs.db
Desktop.ini

# Editors
*.swp
*.swo
*~
.vscode/settings.json

# AI tools
.claude/settings.local.json
.omc/

# Environment
.env
.env.local
```

**Step 4: Commit**

```bash
git add -A
git commit -m "feat: add initial config files"
```

---

### Task 2: install.sh

**Files:**
- Create: `install.sh`

**Step 1: Write install.sh**

The script must:
1. Detect OS (macOS / WSL / Linux)
2. Define symlink mappings (source -> target)
3. For each mapping:
   - If target already exists and is not our symlink: ask "Overwrite? [y/N]"
   - If yes: backup to `<file>.backup.<YYYYMMDD>` then create symlink
   - If no: skip
4. Create parent directories if needed (`~/.config/nvim`, etc.)
5. Print summary of what was linked/skipped

Symlink mappings:
| Source (repo) | Target |
|---|---|
| `shell/.zshrc` | `~/.zshrc` |
| `shell/.p10k.zsh` | `~/.p10k.zsh` |
| `vim/.vimrc` | `~/.vimrc` |
| `config/nvim` | `~/.config/nvim` |
| `config/zellij` | `~/.config/zellij` |
| `config/git` | `~/.config/git` |

**Step 2: Make executable and test**

```bash
chmod +x install.sh
./install.sh
```

Verify symlinks are created correctly with `ls -la ~/.zshrc` etc.

**Step 3: Commit**

```bash
git add install.sh
git commit -m "feat: add install script with interactive symlink setup"
```

---

### Task 3: bin/dotfiles CLI

**Files:**
- Create: `bin/dotfiles`

**Step 1: Write bin/dotfiles**

Subcommands:
- `dotfiles sync` - `git -C ~/dotfiles pull --rebase` + re-run symlink check
- `dotfiles push` - stage all, prompt for commit message, commit + push
- `dotfiles status` - show `git status` + remote comparison
- `dotfiles edit` - open `~/dotfiles` in `$EDITOR`
- `dotfiles help` - show available commands

**Step 2: Make executable and test each subcommand**

```bash
chmod +x bin/dotfiles
bin/dotfiles help
bin/dotfiles status
```

**Step 3: Commit**

```bash
git add bin/dotfiles
git commit -m "feat: add dotfiles CLI with sync/push/status/edit commands"
```

---

### Task 4: Update Notification in .zshrc

**Files:**
- Modify: `shell/.zshrc`

**Step 1: Add dotfiles update check to .zshrc**

Add at the end of `.zshrc`:

1. Add `~/dotfiles/bin` to PATH
2. Background `git fetch` on shell start
3. `precmd` hook: compare local vs remote HEAD
4. If different: print message and prompt `Apply now? [Y/n]:`
5. Default (Enter) runs `dotfiles sync`, `n` skips
6. Only prompt once per session (flag variable)

**Step 2: Test by sourcing**

```bash
source ~/.zshrc
```

**Step 3: Commit**

```bash
git add shell/.zshrc
git commit -m "feat: add dotfiles update notification on shell start"
```

---

### Task 5: README.md and Design Doc

**Files:**
- Create: `README.md`
- Create: `docs/design.md`

**Step 1: Write README.md**

Contents:
- Project description
- Quick start (clone + install)
- Directory structure
- Available commands (`dotfiles sync/push/status/edit`)
- Supported platforms
- How update notifications work

**Step 2: Write docs/design.md**

Contents:
- Design decisions and rationale
- Symlink mapping table
- OS detection strategy
- Update notification mechanism
- Future considerations (git config, package management, etc.)

**Step 3: Commit**

```bash
git add README.md docs/design.md
git commit -m "docs: add README and design documentation"
```

---

### Task 6: .gitignore and Final Verification

**Files:**
- Create: `.gitignore`

**Step 1: Create repo .gitignore**

```
.omc/
.DS_Store
*.backup.*
```

**Step 2: Verify full setup**

- All files in correct locations
- `install.sh` runs without error
- `dotfiles` CLI subcommands work
- Symlinks point to correct targets

**Step 3: Final commit**

```bash
git add .gitignore
git commit -m "chore: add .gitignore and finalize setup"
```
