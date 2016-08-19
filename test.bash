#!/usr/bin/bash

git reset --hard __qwe

git filter-branch -f --commit-filter '
  export ORIGIN_TREE=$(git ls-tree $1)
  export MODIFIED_TREE=$(echo "$ORIGIN_TREE" | grep -v -P "(delete.txt)")
  
  if [[ "$#" = "1" && "$MODIFIED_TREE" != "" ]];
    then
      git commit-tree `echo "$(printf "$MODIFIED_TREE" | git mktree) ${@:2}"`
	  exit 0
	else
      for i in `seq 3 2 $#`;
      do
        if [ "$(git ls-tree ${!i})" != "$MODIFIED_TREE" ];
          then
			git commit-tree `echo "$(printf "$MODIFIED_TREE" | git mktree) ${@:2}"`
			exit
        fi
      done
	  
      for i in `seq 3 2 $#`;
      do
		printf "${!i}"
	  done
      #git commit-tree `echo "$(printf "$MODIFIED_TREE" | git mktree) ${@:2}"`
  fi
' HEAD

