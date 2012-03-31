#!/bin/bash
echo "Watching *.tex files"
while inotifywait *.tex ; do
	echo "File modified, recompiling div"
	sleep 2
	latex -interaction=nonstopmode intro.tex
	pdflatex -interaction=nonstopmode intro.tex
	echo "compiled"
done

