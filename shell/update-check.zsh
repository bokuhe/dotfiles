#-------------------------------------------------------------
# Dotfiles update notification
#-------------------------------------------------------------
if [[ -d "$DOTFILES_DIR/.git" ]]; then
  # Synchronous fetch with timeout (3s) — portable via perl alarm()
  perl -e 'alarm(3); exec @ARGV' git -C "$DOTFILES_DIR" fetch origin --quiet 2>/dev/null

  local branch remote_ref local_head remote_head
  branch="$(git -C "$DOTFILES_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)"
  if [[ -n "$branch" ]]; then
    remote_ref="$(git -C "$DOTFILES_DIR" for-each-ref --format='%(upstream:short)' "refs/heads/${branch}" 2>/dev/null)"
    if [[ -n "$remote_ref" ]]; then
      local_head="$(git -C "$DOTFILES_DIR" rev-parse HEAD 2>/dev/null)"
      remote_head="$(git -C "$DOTFILES_DIR" rev-parse "$remote_ref" 2>/dev/null)"
      if [[ -n "$local_head" && -n "$remote_head" && "$local_head" != "$remote_head" ]]; then
        local behind
        behind="$(git -C "$DOTFILES_DIR" rev-list --count "HEAD..${remote_ref}" 2>/dev/null || echo 0)"
        if [[ "$behind" -gt 0 ]]; then
          echo ""
          echo -e "\033[0;34m[dotfiles]\033[0m Updates available (${behind} commit(s) behind)."
          printf "\033[0;34mApply now? [Y/n]: \033[0m"
          read -r answer
          if [[ -z "$answer" ]] || [[ "$answer" == "y" ]] || [[ "$answer" == "Y" ]]; then
            dotfiles sync
          fi
        fi
      fi
    fi
  fi
fi
