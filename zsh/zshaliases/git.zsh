function branchchris {
git fetch && git switch -c chrisleech-$1 origin/master
}

function branchcexp {
  git fetch && git switch -c chrisleech-cor-$1 origin/master
}

function newbranch {
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
