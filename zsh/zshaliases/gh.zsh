# get formatted message for PR review to post in Slack
alias pr-slack='gh pr view $(git branch --show-current) --json title,url --template ":github-favicon: {{.title}} $'\n':pr-arrow: {{.url}}" | pbcopy'

# opens new PR window in browser
alias newpr="gh pr create --web -t"

# github merge and delete branch
alias ghm="gh pr merge -sd"

alias gr="AUTODETECT_DEVPROXY_PORT=4560 go run"

# pr for current branch
alias ghpr="!gh pr view"

# link for the current branches pr
alias  gprlink="!gh pr view --web"

# create a new pull request from the curent branch
alias  gprnew="!gh pr create --draft"


# get pr details and copy to clipboard formatted for slack
function copypr() {
    echo "⏳ Reading pull request $1..."
    content=$(gh pr view $1 --json additions,deletions,title,url)

    title=$(echo $content | jq -r '.title')
    url=$(echo $content | jq -r '.url')
    additions=$(echo $content | jq -r '.additions')
    deletions=$(echo $content | jq -r '.deletions')

    echo -e ":github-green: $title (+$additions, -$deletions)\n:pr-arrow-darkmode: $url" | pbcopy

    echo "✅ Pull request copied to clipboard in Slack format."
}
