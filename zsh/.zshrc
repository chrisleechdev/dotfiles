export DOTFILES="$HOME/dotfiles"

export MONZO="$GOPATH/src/github.com/monzo"
[ -f ${GOPATH}/src/github.com/monzo/starter-pack/zshrc ] && source $HOME/src/github.com/monzo/starter-pack/zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

source $HOME/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

MAGIC_ENTER_GIT_COMMAND='git status -u .'
MAGIC_ENTER_OTHER_COMMAND='ls -lh .'

export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"

for file in ${ZDOTDIR:-$HOME}/zshaliases/* ; do
    if [ -f "$file" ] ; then
        source "$file"
    fi
done

export PATH=/opt/homebrew/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

