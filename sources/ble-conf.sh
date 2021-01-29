_blerc_prompt_git_vars=(git_base)

function blerc/prompt/git/initialize {
  type git &>/dev/null || return 1
  local path=$PWD
  while
    if [[ -f $path/.git/HEAD ]]; then
      git_base=$path
      return 0
    fi
    [[ $path == */* ]]
  do path=${path%/*}; done
  return 1
}
function blerc/prompt/git/get-head-information {
  branch= hash=

  local head_file=$git_base/.git/HEAD
  [[ -s $head_file ]] || return 1
  local content; ble/util/mapfile content < "$head_file"

  if [[ $content == *'ref: refs/heads/'* ]]; then
    branch=${content#*refs/heads/}

    local branch_file=$git_base/.git/refs/heads/$branch
    [[ -s $branch_file ]] || return 1
    local content; ble/util/mapfile content < "$branch_file"
  fi

  [[ ! ${content//[0-9a-fA-F]} ]] && hash=$content
  return 0
}
function blerc/prompt/git/get-tag-name {
  tag=
  local hash=$1; [[ $hash ]] || return 1

  local file tagsdir=$git_base/.git/refs/tags hash1
  local files ret; ble/util/eval-pathname-expansion '"$tagsdir"/*'; files=("${ret[@]}")
  for file in "${files[@]}"; do
    local tag1=${file#$tagsdir/}
    [[ -s $file ]] || continue
    ble/util/mapfile hash1 < "$file"
    if [[ $hash1 == "$hash" ]]; then
      tag=$tag1
      return 0
    fi
  done
}
function blerc/prompt/git/describe-head {
  ret=

  local hash branch
  blerc/prompt/git/get-head-information
  if [[ $branch ]]; then
    local sgr=$'\e[1;34m' sgr0=$'\e[m'
    ret=$sgr$branch$sgr0
    [[ $hash ]] && ret="$ret (${hash::7})"
    return 0
  fi

  local DETACHED=$'\e[91mDETACHED\e[m'

  local tag
  blerc/prompt/git/get-tag-name "$hash"
  if [[ $tag ]]; then
    local sgr=$'\e[1;32m' sgr0=$'\e[m'
    ret=$sgr$tag$sgr0
    [[ $hash ]] && ret="$ret ${hash::7}"
    ret="$DETACHED ($ret)"
    return 0
  fi

  if [[ $hash ]]; then
    ret="$DETACHED (${hash::7})"
    return 0
  fi

  ret=$'\e[91mUNKNOWN\e[m'
}

function ble/prompt/backslash:X {
  local "${_blerc_prompt_git_vars[@]}"
  if blerc/prompt/git/initialize; then
    local sgr=$'\e[1m' sgr0=$'\e[m'
    local name=$sgr${git_base##*?/}$sgr0
    local ret; blerc/prompt/git/describe-head; local branch=$ret
    ble/prompt/print "$name $branch"
    [[ $PWD == "$git_base"/?* ]] &&
      ble/prompt/print " /${PWD#$git_base/}"
  else
    ble/prompt/process-prompt-string '\w'
  fi

  return 0
}
bleopt prompt_rps1='\X'
#bleopt prompt_rps1_transient=1
