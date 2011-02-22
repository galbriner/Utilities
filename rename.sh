#!/bin/bash

function replace_space_with_underscore {
	first=${1/" "*/}
	if [ $first != $1 ]
	then
		second=${1/*" "/}
		new_name="${first}_${second}"
		mv $1 $new_name
	fi
}

#find the max depth of the configuration directories
MAX_DEPTH=`find . -printf '%d\n' | sort -n  | tail -1`

#set the delemiter to new line instead of space, becuase we got files with space in them.
IFS=$(echo -en "\n\b")

#lower case the directories.
for i in $(seq 1 1 $MAX_DEPTH)
do
	for dir in `find . -maxdepth $i -type d`
	do
		lc=$(echo $dir | tr "[:upper:]" "[:lower:]")
		#make sure the directory isn't already with lowercase.
		if [ $dir != $lc ]
		then
			echo "mv $dir $lc"
			mv $dir $lc
		fi

		#replace space with underscore if needed.
		replace_space_with_underscore $lc
	done
done

#lower case the files.
for file in `find . -type f`
do
	lc=$(echo $file | tr "[:upper:]" "[:lower:]")
	#make sure the file isn't already with lowercase.
	if [ $file != $lc ]
	then
		echo "mv $file $lc"
		mv $file $lc
	fi

	#replace space with underscore if needed.
	replace_space_with_underscore $lc

	#process the internal of the file, make that lowercase too.
	/usr/bin/perl uc2lc.pl $lc $1
done

IFS=$SAVEIFS



