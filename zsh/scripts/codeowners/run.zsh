#!/usr/bin/env bash

# Finds every usage of errortracking.CaptureError calls in a given codeowners services,
# excluding generated files which obviously won't contain them.
#
# Usage:
# ./run.sh <codeowners-team-name-here>

if [[ -z "${GOPATH}" ]]; then
  echo "Gopath is unset, we need this to find the wearedev root"
  exit 1
fi

# Grab the wearedev path from the env, this means we can run the script
# from anywhere, without it breaking
WEAREDEV="${GOPATH}/src/github.com/monzo/wearedev"
CODEOWNERS_FILE="${WEAREDEV}/CODEOWNERS"

TEAM=$1

# Check that a team name has been provided.
if [ -z "$1" ]
then
    echo "Please provide a codeowners team name"
    exit 1
fi

# Find all of the services this team owns.
SERVICES=$(grep -E "^\/[a-zA-Z\.\/-]+ @monzo\/$TEAM" "$CODEOWNERS_FILE"  | awk -F" " '{gsub(/\//, "", $1); print $1}')

if [ -z "$SERVICES" ]; then
  echo "Couldn't find any services for $TEAM, perhaps the team name is incorrect?"
  exit 1
fi

echo "$SERVICES"
