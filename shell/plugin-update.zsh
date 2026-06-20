#-------------------------------------------------------------
# Auto-update third-party zsh repos (framework, theme, plugins)
#
# The clone-if-missing logic in .zshrc only installs these git repos when
# absent; it never refreshes them, so they silently go stale (e.g. a 2021
# powerlevel10k that could not render newer prompt modes). This throttled
# check fast-forwards each managed repo at most once every
# $ZSH_PLUGIN_UPDATE_DAYS days, in the background, so shell startup stays
# instant. Updates land on the next shell launch.
#
# Set ZSH_PLUGIN_UPDATE_DAYS=0 to disable.
#-------------------------------------------------------------

: ${ZSH_PLUGIN_UPDATE_DAYS:=7}
: ${ZSH_CUSTOM:="${ZSH:-$HOME/.oh-my-zsh}/custom"}

__zsh_plugin_update_stamp="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-plugin-update-check"

__zsh_plugin_autoupdate() {
  # Managed git repos: oh-my-zsh framework + theme + custom plugins.
  local -a repos=(
    "${ZSH:-$HOME/.oh-my-zsh}"
    "$ZSH_CUSTOM/themes/powerlevel10k"
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    "$ZSH_CUSTOM/plugins/zsh-z"
  )

  local repo branch
  for repo in "$repos[@]"; do
    [[ -d "$repo/.git" ]] || continue
    # Never clobber local edits — skip any repo with uncommitted changes.
    [[ -z "$(git -C "$repo" status --porcelain 2>/dev/null)" ]] || continue
    branch="$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)" || continue

    # --depth=1 keeps the fetch cheap and works for both shallow and full
    # clones. reset --hard (rather than merge --ff-only) is reliable even on
    # shallow repos where local history isn't a known ancestor of the remote.
    git -C "$repo" fetch --quiet --depth=1 origin "$branch" 2>/dev/null || continue
    [[ "$(git -C "$repo" rev-parse HEAD 2>/dev/null)" == \
       "$(git -C "$repo" rev-parse FETCH_HEAD 2>/dev/null)" ]] && continue
    git -C "$repo" reset --hard --quiet FETCH_HEAD 2>/dev/null
  done
}

# Throttle: run only when the stamp is missing or older than the interval.
# Touch the stamp first so a flaky network doesn't retry on every startup.
if (( ZSH_PLUGIN_UPDATE_DAYS > 0 )) && { [[ ! -f "$__zsh_plugin_update_stamp" ]] || \
     [[ -n "$(find "$__zsh_plugin_update_stamp" -mtime +${ZSH_PLUGIN_UPDATE_DAYS} 2>/dev/null)" ]]; }; then
  mkdir -p "${__zsh_plugin_update_stamp:h}"
  touch "$__zsh_plugin_update_stamp"
  # Detach so startup stays instant; results apply on the next shell launch.
  ( __zsh_plugin_autoupdate & ) >/dev/null 2>&1
fi

unset __zsh_plugin_update_stamp
