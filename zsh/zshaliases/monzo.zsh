# Aliases for commonly used Monzo repos
alias wad="~/src/github.com/monzo/wearedev/"
alias web="~/src/github.com/monzo/web-projects/"
alias pubweb="~/src/github.com/monzo/public-web-projects/"

# Shorthands for deployment. Usage: `ship <pr or branch name>`
alias shipper="caffeinate -dis shipper"
alias ship="shipper deploy --skip-confirm-rollout --s101 --disable-progressive-rollouts"
alias shipp="shipper deploy --skip-confirm-rollout --prod"

alias prw="fzf --bind ctrl-u:preview-page-up,ctrl-d:preview-page-down --preview 'bat --style=numbers --color=always {}'"
alias protos="find . -type f -name '*.proto' | prw"

# Watch all files for changes, and run tests when they change.
watchtests() {
    if ! command -v fd &> /dev/null; then
        echo "fd not installed"
        return 1
    fi
    if ! command -v entr &> /dev/null; then
        echo "fd not installed"
        return 1
    fi

    fd -e go | entr -c sh -c "go test ./... && echo ✅ || echo ❌"
}

# sets the port so locally built services can be picked up by devproxy
alias devproxy="AUTODETECT_DEVPROXY_PORT=4560"

# Watch all files for changes, and build when they change using the devproxy port.
watchbuild() {
    if ! command -v fd &> /dev/null; then
        echo "fd not installed"
        return 1
    fi
    if ! command -v entr &> /dev/null; then
        echo "fd not installed"
        return 1
    fi

    fd -e go | entr -c sh -c "devproxy go build ./... && echo ✅ || echo ❌"
}


# Ship the current branch to s101 or prod.
#
# Deploy to staging:    yeet
# Deploy to prod:       yeet prod
yeet() {
	if [ "$#" -eq 0 ]; then
        env="s101"
	else
        env="$1"
	fi

    branch=`git rev-parse --abbrev-ref HEAD`
    shipper deploy --environment $env $branch
}


# Run all the codegen for any changed services.
gen() {
    WEAREDEV="$GOPATH/src/github.com/monzo/wearedev"
    LOGFILE="${TMPDIR}gen_log.txt"

    echo "" > $LOGFILE

	if [ "$#" -eq 0 ]; then
		echo "Usage: gen <dir>"
        return 1
	fi

    # Required on OSX:
    # brew install coreutils
    dir=$(basename `realpath $1`)

    # GO GEN #
    echo -ne "$dir: go generate " | tee -a $LOGFILE
    go generate "$WEAREDEV/$dir/..." > $LOGFILE
    echo "✅" | tee -a $LOGFILE

    # MANIFESTS #
    echo -ne "$dir: manifests " | tee -a $LOGFILE
    $WEAREDEV/bin/generate_manifests "$WEAREDEV/$dir" > $LOGFILE
    echo "✅" | tee -a $LOGFILE

    # RPCMAP #
    echo -ne "$dir: rpcmap " | tee -a $LOGFILE
    go run "$WEAREDEV/tools/rpcmap/cmd/rpcmap" -generate "$WEAREDEV/$dir" > $LOGFILE
    echo "✅" | tee -a $LOGFILE

    # PROTOBUFS #
    echo -ne "$dir: protobufs " | tee -a $LOGFILE
    if [ ! -d "$WEAREDEV/$dir/proto" ]; then
        echo "⏭" | tee -a $LOGFILE
    else
        $WEAREDEV/bin/generate_protobufs "$WEAREDEV/$dir" > $LOGFILE
        echo "✅" | tee -a $LOGFILE
    fi

    # GQLGEN #
    echo -ne "$dir: gqlgen " | tee -a $LOGFILE
    if [ ! -d "$WEAREDEV/$dir/graphql" ]; then
        echo "⏭" | tee -a $LOGFILE
    else
        builtin cd "$WEAREDEV/$dir/graphql" > $LOGFILE
        GO111MODULE=auto go run scripts/gqlgen.go > $LOGFILE
        builtin cd "-" > $LOGFILE
        echo "✅" | tee -a $LOGFILE
    fi

    echo "\nLogs: $LOGFILE"
}

gentest() {
  WEAREDEV="$GOPATH/src/github.com/monzo/wearedev"
  LOGFILE="${TMPDIR}gen_log.txt"

  echo "" > $LOGFILE

	if [ "$#" -eq 0 ]; then
		echo "Usage: gentest <dir>"
        return 1
	fi

  dir=$(basename `realpath $1`)


  # Go Test #
  echo -ne "$dir: go test " | tee -a $LOGFILE
  go test "$WEAREDEV/$dir/..." > $LOGFILE

  echo "\nLogs: $LOGFILE"

}

# See which services are being called by a given service.
# e.g. whoscalling service.account
whoscalling() {
    repo="${GOPATH}/src/github.com/monzo/wearedev"
    fd "$1.rule" ${repo}/*/manifests/egress | sed -E "s,^${repo}/([^/]*)(/.*)?,\1,"
}

# find codeowner for a service
owner() {
        repo="${GOPATH}/src/github.com/monzo/wearedev/CODEOWNERS"
        grep "/$1/" ${repo}
}

function ahoy() {
local branch
  branch=$(fgb $1)
  if [ $? -ne 0 ]; then
    return 1
  fi

  if [[ "$branch" = "" ]]; then
    echo "No branch selected"
    return 1
  fi
 shipper deploy --s101 --skip-confirm-rollout $(gh pr list -A "@me" -s all | fzf --sync | awk '{print $1}') 
}

function ahoyp() {
 shipper deploy --prod --skip-confirm-rollout $(gh pr list -A "@me" -s all | fzf --sync | awk '{print $1}') 
}
