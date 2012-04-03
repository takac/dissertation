#!/bin/bash

# Add this to bashrc or completion dir..
#complete -f -X '!*.@(tex)' watch_compile.sh
if [ ${#} -gt 2 ]; then
	echo "Usage: max 2 args expected"
	exit
fi
#TODO 
if [ ${#} == 2 ]; then
	echo "arg echo $1"
	if [ ${1} ]; then
		echo "BAH"
	fi
fi

if [ -z $1 ]; then
	1="*.tex"
else
	if [ ! -e $1 ]; then
		echo "$1 does not exist"
		exit
	fi
	EXT=${1:$((${#1}-4)):4}
	if [ ".tex" != ${EXT,,} ]; then
		echo "Not correct file ext, $1"
		exit
	fi
fi

echo "Watching $1"

while true; do
	FILE=$( inotifywait $1 ) 
	LEN=$( echo $FILE | wc -w )
	FILE=$( echo $FILE | cut -d " " -f$(($LEN - 1)) )

	echo "$FILE modified, recompiling div"
	sleep 1
	#latex -interaction=nonstopmode *.tex > /dev/null
	pdflatex -interaction=nonstopmode $FILE > /dev/null
	#considered using y=${x%.*}
	bibtex $( basename $FILE .tex ) > /dev/null
	cp $( basename $FILE .tex ).pdf /var/www/
	echo "compiled"
done

