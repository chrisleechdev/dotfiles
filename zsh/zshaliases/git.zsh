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

function branchchris {
  git fetch -q && git switch -c chrisleech-$1 origin/master
}

function nbranch {
  git fetch && git switch -c $1 origin/master
}

function lsmerged {
  git fetch -q
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}'
}

function deletemerged {
  git fetch -q
  git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
}


