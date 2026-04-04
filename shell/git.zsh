#-------------------------------------------------------------
# Git
#-------------------------------------------------------------
function git-tagp() {
  if [[ -z "$1" ]]; then
    echo "Usage: git-tagp <tag-name>"
    return 1
  fi
  git tag "$1"
  git push origin "$1"
}
function git-tagd() {
  if [[ -z "$1" ]]; then
    echo "Usage: git-tagd <tag-name>"
    return 1
  fi
  git tag -d "$1"
  git push origin --delete "$1"
}
#alias git-log-since-tag="git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:'%s (%h)'"
function git-sync-tags() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repository. Aborting."
    return 1
  fi

  local remote_name=origin
  local dry_run=false

  for arg in "$@"; do
    if [[ "$arg" == "--dry-run" ]]; then
      dry_run=true
    else
      remote_name="$arg"
    fi
  done

  echo "Syncing tags from remote: '$remote_name'..."
  if [[ "$dry_run" == true ]]; then
    echo "Dry-run mode enabled — no changes will be made."
  fi

  local remote_hash tag_ref tag_name local_hash
  git ls-remote --tags "$remote_name" | grep -v '^\^{}' | while read -r line; do
    remote_hash=$(echo "$line" | awk '{print $1}')
    tag_ref=$(echo "$line" | awk '{print $2}')
    tag_name=${tag_ref#refs/tags/}

    if git show-ref --tags --quiet --verify -- "refs/tags/$tag_name"; then
      local_hash=$(git rev-parse "$tag_name")
      if [[ "$local_hash" != "$remote_hash" ]]; then
        echo "Tag '$tag_name' differs. Replacing local tag with remote version."
        if [[ "$dry_run" == false ]]; then
          git tag -d "$tag_name"
          git fetch "$remote_name" tag "$tag_name"
        fi
      else
        echo "Tag '$tag_name' is up to date."
      fi
    else
      echo "Tag '$tag_name' not found locally. Fetching from remote..."
      if [[ "$dry_run" == false ]]; then
        git fetch "$remote_name" tag "$tag_name"
      fi
    fi
  done

  echo "Tag sync complete. Source: $remote_name"
}
