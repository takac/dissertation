#!/bin/bash

_watch_compile() 
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="--help --verbose --version"

	if [[ ${cur} == -* ]] ; then
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
		return 0
	fi
	if [[ ${cur} == " " ]]; then 
		# could use  ls -1 | while read filename; do echo "$filename"; done
		 local name=$(ls -1 *.tex)
		 COMPREPLY=( $(compgen -W "${names}" -- ${cur}) )
		 return 0
	 fi
}
complete -F  watch_compile watch_compile

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

echo "Watching $1 files"

while true; do
	FILE=`inotifywait $1` 
	LEN=`echo $FILE | wc -w`
	FILE=`echo $FILE | cut -d " " -f$(($LEN - 1))`

	echo "$FILE modified, recompiling div"
	sleep 1
	#latex -interaction=nonstopmode *.tex > /dev/null
	pdflatex -interaction=nonstopmode $FILE > /dev/null
	#considered using y=${x%.*}
	bibtex -interaction=nonstopmode `basename $FILE .tex` > /dev/null
	cp intro.pdf /var/www/
	echo "compiled"
done

