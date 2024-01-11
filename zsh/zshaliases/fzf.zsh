source /opt/homebrew/opt/fzf/shell/completion.zsh


# Default to fd instead of `find`
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'

# Keep colouring
export FZF_DEFAULT_OPTS="--ansi"

# Find and edit.
function fedit() {
    selected=$(rg --files | fzf --preview 'bat --style numbers,changes --color=always --line-range :$LINES {}')
    [ -z "$selected" ] && exit
    eval $EDITOR "$selected"
}

# Find + checkout git branch
function fcheckout() {
    branches=$(git branch --format='%(refname:short)')
    selected=$(echo $branches | fzf --preview 'git log --oneline master..{}')
    [ -z "$selected" ] && exit
    git checkout "$selected"
}

# find and change directory
function fcd() {
    selected=$(fd --type directory | fzf --preview 'tree -L 2 {} | head -n $LINES')
    [ -z "$selected" ] && exit
    cd $selected
}


function fgb() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    if ! command -v fzf &> /dev/null; then
      echo "fzf not installed"
      return 1
    fi

    local flag
    case "$1" in
        local|"") flag="" ;;  # when 'local' or no argument is given, display local branches
        remote) flag="--remote" ;;
        all) flag="--all" ;;
        *) echo "Invalid argument. Please specify 'local', 'remote', or 'all'."; return 1 ;;
    esac

    git branch --color=always $flag --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fcob() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fgb $1)
    if [ $? -eq 1 ]; then  # if fzf-git-branch exited with an error
        return 1
    fi

    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}
