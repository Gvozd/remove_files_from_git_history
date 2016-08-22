#!/usr/bin/bash
export FILES_TO_DELETE="delete.txt"


# TODO - дебаг
git reset --hard __qwe

git filter-branch -f --commit-filter '
	printf "
		export ORIGIN_TREE=\$(git ls-tree \$1)
		export MODIFIED_TREE=\$(echo \"\$ORIGIN_TREE\" | grep -v -P \"(\$FILES_TO_DELETE)\")
		if [[ \"\$#\" = \"1\" && \"\$MODIFIED_TREE\" != \"\" ]];
			then
				git commit-tree \`echo \"\$(printf \"\$MODIFIED_TREE\" | git mktree) \${@:2}\"\`
				exit 0
			else
				for i in \`seq 3 2 \$#\`;
					do
						if [ \"\$(git ls-tree \${!i})\" != \"\$MODIFIED_TREE\" ];
							then
							git commit-tree \`echo \"\$(printf \"\$MODIFIED_TREE\" | git mktree) \${@:2}\"\`
							exit
						fi
					done
			  
				for i in \`seq 3 2 \$#\`;
					do
						printf \"\${!i}\"
					done
		fi
	" | bash /dev/stdin $@
' HEAD

