# fastfetch (system info banner on shell startup)
#
# Prints a compact system summary when an interactive terminal opens, using
# fastfetch's bundled "archey" preset. Optional tool — only runs if fastfetch
# is installed, so machines without it start silently (see "No package
# management" in docs/design.md).
#
# Install per platform — the binary is named `fastfetch` everywhere, but per
# the official docs (github.com/fastfetch-cli/fastfetch) it is not yet in most
# stable distro repos, so several platforms need an extra step:
#   macOS:            brew install fastfetch
#   Ubuntu 25.04+ /   sudo apt install fastfetch
#     Debian 13+
#   Ubuntu < 25.04    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
#     (incl. WSL):    sudo apt update && sudo apt install fastfetch
#                     (or install the .deb from the GitHub releases page)
#   Fedora:           sudo dnf install fastfetch
#   Cygwin/Windows:   winget install fastfetch  (no Cygwin package; install the
#                     native Windows build via winget / scoop / choco)
#
# Guards, cheapest-first so the common skip path costs nothing:
#   -o interactive  — skip non-interactive shells (scripts, `zsh -c '...'`)
#   -t 1            — skip when stdout is captured/piped, not a real terminal
#   command -v      — skip when fastfetch is not installed on this machine
if [[ -o interactive ]] && [[ -t 1 ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch --config archey.jsonc
fi
