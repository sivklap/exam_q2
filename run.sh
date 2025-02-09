#!/bin/bash

#A
if [[ $# -eq 0 ]]; then
	echo "Error"
	exit 1
fi

array=( "$@" )

git pull

#B
for filename in "${array[@]}" ; do
	for file in $(find . -type f -name "*${filename}*.py"); do #added a fix
		git diff ${file} > diff-file_${filename}
	done
done

#C
for file in diff-file_* ; do
	f=$(echo ${file} | cut -f 2 -d "_")
	grep -E "^[+-]" ${file} > diff-plusminus_${f}
done

#bonus D
for file in diff-file_* ; do
	f=$(echo ${file} | cut -f 2 -d "_")
	git add "*${f}*"
	git commit -F diff-plusminus_${f} #`git commit -F` sets the commit message to be the content of the given file
done

# rm diff-file_* diff-plusminus_*
