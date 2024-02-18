#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/jehon/usr/bin/jh-lib
. jh-lib

REPO="${1:?Need repo as [1]}"
TARGET="${2:?Need target as [2]}"
PUSH="$3"
PAGE_BRANCH="gh-pages"

rm -fr "$TARGET"
mkdir -p "$TARGET"

header_begin "Current repo ${REPO}"
ls -l "${REPO}"
header_end

header_begin "Sync git"
rsync -a --delete .git "$TARGET/"
header_end

(
    pushd "$TARGET"

    header_begin "Getting previous $PAGE_BRANCH"
    git reset --hard
    git fetch --all
    git switch --discard-changes "$PAGE_BRANCH"
    git pull --force

    jh_info "Actual status"
    git status
    git branch -vv
    header_end

    header_begin "Keep only latest version of each file"
    # We remove old files and they will be recreated if necessary
    git restore-mtime
    # In days:
    # Please note that it is build every days automatically
    # so latest are always kept
    find . -mtime +3 -delete
    header_end
)

header_begin "Adding new repo ${REPO} to ${TARGET}"
rsync -ai "${REPO}" "$TARGET"
header_end

jh-github-publish-pages "$TARGET" "$PUSH" | jh-tag-stdin "jh-github-publish-pages"
