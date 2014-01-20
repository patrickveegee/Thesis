#!/bin/bash

# Exit on first error
set -o errexit

function wordcount {
    texfile="${1}"
    tcpattern="Words in text: \\(\\d*\\)"
    texcount -total -inc "$texfile" |\
        grep "$tcpattern" |\
        sed "s/$tcpattern/\\1/"
}

# Add all chapter files here
total=0
for t in \
        chapters/introduction/introduction.tex\
        chapters/brewing/brewing.tex\
        chapters/appendices/appendices.tex
do
    count=$(wordcount "${t}")
    echo "${t}             ${count}"
    total=$(($total + $count))
done
echo
echo "Total:   " $total
echo
grep "Word count" frontmatter/title.tex
