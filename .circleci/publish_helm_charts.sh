#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REVISION=${GITHUB_TAG:-$GIT_SHA1}
LOCAL_HELM_MOJALOOP_REPO_URI=https://mojaloop.github.io/charts/repo

echo "DIR=${DIR}"
echo "PWD=${PWD}"

if [ -n "${GITHUB_TAG}" ]; then
  COMMIT_MESSAGE="Updating development release to $REVISION"
else
  COMMIT_MESSAGE="Updating release to $REVISION"
fi

set -eox pipefail

echo "Setting BASH_ENV..." | tee git.log
source $BASH_ENV

echo "Package helm charts..." | tee git.log
"${DIR}"/../scripts/package.sh

WORKING_RELEASE_DIRECTORY=/tmp/release
echo "Cloning fresh directory checked out with release branch" | tee git.log
git clone -b $GITHUB_TARGET_BRANCH --single-branch $CIRCLE_REPOSITORY_URL $WORKING_RELEASE_DIRECTORY &> git.log

echo "Moving packaged charts to release directory and repo folder" | tee git.log
mv repo/*.* $WORKING_RELEASE_DIRECTORY/repo
mv README.md LICENSE.md CODEOWNERS $WORKING_RELEASE_DIRECTORY

echo "Indexing repo folder" | tee git.log
cd $WORKING_RELEASE_DIRECTORY/repo
helm repo index . --url "$LOCAL_HELM_MOJALOOP_REPO_URI"

echo "Switching to release directory" | tee git.log
cd $WORKING_RELEASE_DIRECTORY
git status

echo "Staging general changes..." | tee git.log
git add -A

echo "Staging packaged Helm charts..." | tee git.log
git add -f repo/*.tgz repo/index.yaml ./README.md ./LICENSE.md ./CODEOWNERS

echo "Commiting changes..." | tee git.log
git commit -a -m "'$COMMIT_MESSAGE'"

echo "Publishing $REVISION release to $GITHUB_TARGET_BRANCH on github..." | tee git.log
git push -q origin $GITHUB_TARGET_BRANCH &> git.log
