# mise (polyglot runtime version manager)
#
# Manages versions of Node, Python, Go, Ruby, etc. via a single tool.
# Only activates on machines where mise has been installed by the user.
# Install with: curl https://mise.run | sh
#
# mise is invoked via its absolute path here so activation works even before
# ~/.local/bin is on PATH (the activate hook adds the shims dir itself).

if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
elif command -v mise > /dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
