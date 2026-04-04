#!/usr/bin/env bash
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Auto-detect the dotfiles directory (where this script lives)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Counters
linked=0
skipped=0
backed_up=0

# OS Detection
detect_os() {
    local kernel
    kernel="$(uname -r)"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "macOS"
    elif echo "$kernel" | grep -qi "microsoft"; then
        echo "WSL"
    else
        echo "Linux"
    fi
}

OS="$(detect_os)"
echo -e "${BLUE}Detected OS: ${OS}${RESET}"
echo -e "${BLUE}Dotfiles directory: ${DOTFILES_DIR}${RESET}"
echo ""

# Symlink mappings: "source:target"
mappings=(
    "shell/.zshrc:$HOME/.zshrc"
    "vim/.vimrc:$HOME/.vimrc"
    "config/nvim:$HOME/.config/nvim"
    "config/zellij:$HOME/.config/zellij"
    "config/git:$HOME/.config/git"
)

link_item() {
    local src="$1"
    local target="$2"

    # Create parent directory if needed
    local parent
    parent="$(dirname "$target")"
    if [[ ! -d "$parent" ]]; then
        mkdir -p "$parent"
    fi

    # Already a symlink pointing to our source -> skip
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$src" ]]; then
        echo -e "${YELLOW}[SKIPPED]${RESET}  $target (already linked)"
        (( skipped++ )) || true
        return
    fi

    # Target exists (file, dir, or wrong symlink) -> prompt
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        local display_target="${target/$HOME/\~}"
        printf "%b" "${YELLOW}${display_target} already exists. Overwrite? [y/N]: ${RESET}"
        read -r answer
        if [[ "$answer" == "y" ]] || [[ "$answer" == "Y" ]]; then
            local backup="${target}.backup.$(date +%Y%m%d)"
            mv "$target" "$backup"
            ln -s "$src" "$target"
            echo -e "${GREEN}[BACKUP + LINKED]${RESET}  $target (backup: $backup)"
            (( backed_up++ )) || true
            (( linked++ )) || true
        else
            echo -e "${YELLOW}[SKIPPED]${RESET}  $target (kept existing)"
            (( skipped++ )) || true
        fi
        return
    fi

    # Target does not exist -> create symlink
    ln -s "$src" "$target"
    echo -e "${GREEN}[LINKED]${RESET}   $target -> $src"
    (( linked++ )) || true
}

for mapping in "${mappings[@]}"; do
    rel_src="${mapping%%:*}"
    target="${mapping##*:}"
    abs_src="${DOTFILES_DIR}/${rel_src}"
    link_item "$abs_src" "$target"
done

echo ""
echo -e "${BLUE}Done.${RESET}"
echo -e "  Linked:    ${GREEN}${linked}${RESET}"
echo -e "  Backed up: ${GREEN}${backed_up}${RESET}"
echo -e "  Skipped:   ${YELLOW}${skipped}${RESET}"
echo ""
echo -e "${BLUE}Note:${RESET} The dotfiles CLI tools are available in ~/dotfiles/bin."
echo "      Your .zshrc already adds this to PATH automatically."
