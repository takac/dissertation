#!/bin/bash
echo "Watching *.tex files"
while inotifywait *.tex ; do
	echo "File modified, recompiling div"
	sleep 1
	latex -interaction=nonstopmode intro.tex
	pdflatex -interaction=nonstopmode intro.tex
	cp intro.pdf /var/www/
	echo "compiled"
done

