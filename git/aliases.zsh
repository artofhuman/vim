# The rest of my fun git aliases
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gc='git commit -v'
alias gca='git commit -a -v'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"
alias gmc='git diff --name-only --diff-filter=U' # show only files with merge conflicts
alias hpr='hub pull-request'

alias rebase='git rebase -i HEAD~2'
alias rebase3='git rebase -i HEAD~3'
alias rebase4='git rebase -i HEAD~4'
alias rebase5='git rebase -i HEAD~5'
