REPO="${NH_FLAKE:-}"
REMOTE=origin

if [[ -z "$REPO" || ! -d "$REPO/.git" ]]; then
  echo "Error: NH_FLAKE is not a git repository"
  exit 1
fi

cd "$REPO" || exit 1

git fetch --quiet "$REMOTE"

BRANCH=$(git symbolic-ref --quiet "refs/remotes/$REMOTE/HEAD" |
  sed "s@^refs/remotes/$REMOTE/@@") || {
  echo "Error: Could not determine remote HEAD"
  exit 1
}

UPSTREAM="$REMOTE/$BRANCH"

BEHIND=$(git rev-list --count HEAD.."$UPSTREAM")

if ((BEHIND > 0)); then
  echo "Config behind by $BEHIND commit(s)"
  exit 0
else
  echo "Config up to date"
  exit 1
fi
