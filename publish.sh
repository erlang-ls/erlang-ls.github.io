#!/usr/bin/env sh -ex

REMOTE=${REMOTE:-origin}
BRANCH=master
SITEDIR=site
COMMIT=$(git rev-parse --short HEAD)

# Verify the site is already built, and move it to a temporary
# location
if [ ! -d "$SITEDIR" ]; then
  echo "$SITEDIR is missing: run 'make build' before publishing" >&2
  exit 1
fi
TMPDIR=$(mktemp -d)
mv "$SITEDIR" "$TMPDIR"

# Switch to the publishing branch
git fetch -p "$REMOTE"
if git show-ref "$REMOTE/$BRANCH" > /dev/null; then
  git checkout "$REMOTE/$BRANCH"
else
  git checkout "$COMMIT"
fi

# Delete all files currently in the repo, and move the site back from
# the temporary location to the root directory of the repo
git ls-tree --name-only HEAD | xargs git rm -r
TMPROOT="$TMPDIR/$(basename $SITEDIR)"
for source in $(find "$TMPROOT" -type f)
do
  target=${source#"${TMPROOT}/"}
  mkdir -p $(dirname $target)
  mv $source $target
  git add $target
done

# Commit, push and clean up
git commit -m "${COMMIT} published: $(date)"
git push origin HEAD:$BRANCH
git checkout @{-1}
rm -rf "$TMPDIR"
