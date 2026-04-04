#-------------------------------------------------------------
# Git
#-------------------------------------------------------------
function git-tagp() {
  git tag $1
  git push origin $1
}
function git-tagd() {
  git tag -d $1
  git push origin --delete $1
}
#alias git-log-since-tag="git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:'%s (%h)'"
function git-sync-tags() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "⚠️ Not a git repository. Aborting."
    return 1
  fi

  REMOTE_NAME=origin
  DRY_RUN=false

  for arg in "$@"; do
    if [[ "$arg" == "--dry-run" ]]; then
      DRY_RUN=true
    else
      REMOTE_NAME="$arg"
    fi
  done

  echo "🔁 Syncing tags from remote: '$REMOTE_NAME'..."
  if [ "$DRY_RUN" = true ]; then
    echo "🧪 Dry-run mode enabled — no changes will be made."
  fi

  git ls-remote --tags "$REMOTE_NAME" | grep -v '^\^{}' | while read -r line; do
    REMOTE_HASH=$(echo "$line" | awk '{print $1}')
    TAG_REF=$(echo "$line" | awk '{print $2}')
    TAG_NAME=${TAG_REF#refs/tags/}

    if git show-ref --tags --quiet --verify -- "refs/tags/$TAG_NAME"; then
      LOCAL_HASH=$(git rev-parse "$TAG_NAME")
      if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        echo "🔄 Tag '$TAG_NAME' differs. Would replace local tag with remote version."
        if [ "$DRY_RUN" = false ]; then
          git tag -d "$TAG_NAME"
          git fetch "$REMOTE_NAME" tag "$TAG_NAME"
        fi
      else
        echo "✅ Tag '$TAG_NAME' is up to date."
      fi
    else
      echo "⬇️  Tag '$TAG_NAME' not found locally. Fetching from remote..."
      if [ "$DRY_RUN" = false ]; then
        git fetch "$REMOTE_NAME" tag "$TAG_NAME"
      fi
    fi
  done

  echo "🏁 Tag sync complete. Source: $REMOTE_NAME"
}
