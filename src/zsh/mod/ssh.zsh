#!/usr/bin/env bash
# -*- coding: utf-8 -*-

alias sak="ssh-add -K"
remote() {
  ssh $1 -t 'screen -qR'
}

forward() {
  ssh -L ${1}:localhost:${1} -N ${2}
}
alias forward-vnc="forward 5900"
alias forward-jupyter="forward 18888"

# remote worker scripts
export WORKER=com

sk() {
  echo 🚀 Syncing to $WORKER
  rsync -C --filter=":- .gitignore" --exclude=".git*" -avz . ${WORKER}:jobs/$(basename $PWD)
}

receive() {
  rsync -C --exclude=".git*" -avz ${WORKER}:jobs/$(basename $PWD)/$1 ./$1
  echo "📞 Receiving \"$1\" on $WORKER"
}

run() {
  ssh -t $WORKER "cd jobs/$(basename $PWD); zsh -ic \"$@\"" 2>/dev/null
  echo "🏃 Running \"$@\" on $WORKER"
}

skrun() {
  sk && echo '' && run $@
}

dive() {
  ssh -t $WORKER "cd jobs/$(basename $PWD); zsh"
  echo "🎯 Dive into jobs/$(basename "$PWD") on $WORKER"
}