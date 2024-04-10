# why use lot words when few do trick
alias branch="git checkout -b"

# amend previous commit
alias amend="git commit --amend --no-edit"

# Show all uncommitted TODOs and FIXMEs
alias todos="c; git diff | grep TODO | grep + | grep -v ISAV- | sed 's/+//g' | sed 's/$TAB//g'; git diff | grep FIXME | grep + | grep -v ISAV- | sed 's/+//g' | sed 's/$TAB//g'"

# Revert the last commit
alias whoops="git reset --soft HEAD~1"

# Checkout master and pull quietly
alias gcmp="git checkout master && git pull"

# Merge master into feature branch
alias gfm="git fetch && git merge origin/master"

# Add using interactive prompt
alias gap='git add -p'

# functions

function cbranch {
  local branch_name="${1//[ _]/-}"  # Replace spaces and underscores with hyphens
  git fetch && git switch -c "chrisl-$branch_name" origin/master
}


function nbranch {
  local branch_name="${1//[ _]/-}"  # Replace spaces and underscores with hyphens
  git fetch && git switch -c "$branch_name" origin/master
}

function create_branch {
  local prefix="${2:-}"  # Optional prefix, default is empty
  local branch_name="${1//[ _]/-}"  # Replace spaces and underscores with hyphens
  
  if [[ -n "$prefix" ]]; then
    branch_name="${prefix}-${branch_name}"
  fi

  git fetch && git switch -c "$branch_name" origin/master
}


function lsmerged {
  git fetch -q
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}'
}

function deletemerged {
  git fetch -q
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
}

function get_branch {
    local branch
    branch=$(fgb $1)
    if [ $? -ne 0 ]; then
        return 1
    fi

    if [[ "$branch" = "" ]]; then
        echo "No branch selected"
        return 1
    fi

    echo "$branch"
}
