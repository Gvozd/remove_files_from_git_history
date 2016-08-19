#!/usr/bin/bash
# аргументы начиная со второго
# echo "${@:2}"

# перебрать только четные элементы
# for i in `seq 3 2 $#`; do echo ${!i}; done
git reset --hard __qwe
echo "" > /c/Projects2/test-repo/qwe.log
  # export ORIGIN_TREE=`git ls-tree $1`
  # export MODIFIED_TREE=`echo "$ORIGIN_TREE" | grep -v -P "(delete.txt)"`
  # echo "$MODIFIED_TREE" | git mktree
#git filter-branch -f --commit-filter '
#	git commit-tree `
#		export QWE=$(git ls-tree $1 | grep -v -P "(delete.txt)")
#		printf "[$QWE]\n" >> /c/Projects2/test-repo/qwe.log
#		echo "[$QWE]n" >> /c/Projects2/test-repo/qwe.log
#		echo "===" >> /c/Projects2/test-repo/qwe.log
#		printf "$QWE" | git mktree
#	` $2 $3 $4 $5 $6 $7 $8 $9
#' HEAD
#exit 0

git filter-branch -f --commit-filter '
  export ORIGIN_TREE=$(git ls-tree $1)
  export MODIFIED_TREE=$(echo "$ORIGIN_TREE" | grep -v -P "(delete.txt)")
  printf "\- ORIGIN_TREE\n$ORIGIN_TREE\n" >> /c/Projects2/test-repo/qwe.log
  printf "\- MODIFIED_TREE\n$MODIFIED_TREE\n" >> /c/Projects2/test-repo/qwe.log
  
  if [[ "$#" = "1" && "$MODIFIED_TREE" != "" ]];
    then
      git commit-tree `echo "$(printf "$MODIFIED_TREE" | git mktree) ${@:2}"`
	  exit 0
	else
      for i in `seq 3 2 $#`;
      do
        printf "+ parent ${!i}\n$(git ls-tree ${!i})\n" >> /c/Projects2/test-repo/qwe.log
        if [ "$(git ls-tree ${!i})" != "$MODIFIED_TREE" ];
          then
            echo "OK" >> /c/Projects2/test-repo/qwe.log
			git commit-tree `echo "$(printf "$MODIFIED_TREE" | git mktree) ${@:2}"`
			exit
        fi
      done
	  
      for i in `seq 3 2 $#`;
      do
		printf "${!i}"
	  done
      printf "======\n" >> /c/Projects2/test-repo/qwe.log
      #git commit-tree `echo "$(printf "$MODIFIED_TREE" | git mktree) ${@:2}"`
  fi
' HEAD

