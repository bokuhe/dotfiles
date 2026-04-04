# Claude Code Instructions

## Documentation-first workflow

- At the start of every session, read `README.md` and `docs/design.md` to understand project context before making changes.
- When code is modified, update related documentation (README, design docs) in the same session.
- Create new docs under `docs/` when introducing significant new features or design decisions.
- Documentation should stay in sync with code at all times.

## Project conventions

- Shell config lives in `shell/`. Logically distinct sections are extracted to separate `.zsh` files and sourced from `.zshrc`.
- Platform support: macOS (Intel, Apple Silicon), Linux (Ubuntu, Fedora), WSL, Cygwin. All changes must work across these platforms without requiring additional tool installation.
- `DOTFILES_DIR` is defined at the top of `.zshrc` and used throughout. Do not hardcode `~/dotfiles` elsewhere.
