#!/bin/bash

#find the max depth of the configuration directories
MAX_DEPTH=`find . -printf '%d\n' | sort -n  | tail -1`

#set the delemiter to new line instead of space, becuase we got files with space in them.
IFS=$(echo -en "\n\b")

#lower case the directories.
for i in $(seq 1 1 $MAX_DEPTH)
do
	for dir in `find . -maxdepth $i -type d`
	do
		#replace uppercase with lowercase, and space with underscore.
		lc=$(echo $dir | tr "[:upper:]" "[:lower:]")
		lc=$(echo $lc | tr " " "_")

		#make sure the directory isn't already with lowercase.
		if [ $dir != $lc ]
		then
			echo "mv $dir $lc"
			mv $dir $lc
		fi
	done
done

#lower case the files.
for file in `find . -type f`
do
	#replace uppercase with lowercase, and space with underscore.
	lc=$(echo $file | tr "[:upper:]" "[:lower:]")
	lc=$(echo $lc | tr " " "_")

	#make sure the file isn't already with lowercase.
	if [ $file != $lc ]
	then
		echo "mv $file $lc"
		mv $file $lc
	fi

	#process the internal of the file, make that lowercase too.
	/usr/bin/perl uc2lc.pl $lc $1
done

IFS=$SAVEIFS



