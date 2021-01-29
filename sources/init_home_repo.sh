#!/bin/bash

if [[ -z $1 || -z $2 ]]
then
  echo "Usage: ${0##*/} <ssh host> <remote repo name>"
  exit 1
fi

readonly host=$1
readonly gitdir=${2%.git}.git

foo()
{
  dir=~git/r/$1

  if test -d "$dir"
  then
    echo "Git directory '$dir' already exists"
    exit 1
  fi

  mkdir "$dir" \
    && git init --bare "$dir" \
    && chown -R git:git "$dir" \
    && ls -Alh "$dir" \
    || (echo "Failure. Deleting '$dir'"; rm -vrf "$dir"; exit 1)
}

ssh "$host" "$(declare -fp foo); foo '$gitdir'" \
  && git remote -v add home "git@${host#*@}:r/$gitdir"

