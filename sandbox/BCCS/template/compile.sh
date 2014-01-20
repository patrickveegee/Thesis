#!/bin/bash

# Exit on first error
set -o errexit

# Main project name
JOB=thesis

# Clean up
if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]; then
    echo "compile.sh [OPTION]"
    echo ""
    echo "Builds "$JOB.tex" into "$JOB.pdf" using pdflatex, bibtex and"
    echo "makeglossaries."
    echo ""
    echo "Options:"
    echo "-h, --help  : show this help message and exit"
    echo "-w, --words : show word count and exit"
    echo "-c, --clean : delete temporary files and exit"
    exit
fi

# Latex produces loads of unwanted files.
# -c flag deletes them all (without prompting)
if [[ "$1" = "-c" || "$1" = "--clean" ]]; then
    rm -fv "$JOB.log" "$JOB.aux"            # LaTeX files
    rm -fv "$JOB.lof" "$JOB.lot" "$JOB.toc" # Contents files
    rm -fv "$JOB.bbl" "$JOB.blg"            # BiBTeX files
    rm -fv "$JOB.out"                       # hyperref file
    rm -fv "$JOB.ilg" "$JOB.ind" "$JOB.nlo" "$JOB.nls" # makeindex files
    rm -fv "$JOB.acn" "$JOB.acr" "$JOB.alg" \
           "$JOB.glg" "$JOB.glo" "$JOB.gls" "$JOB.ist" # makeglossary files
    echo ""
    ls --color=always -Xl
    exit
fi

# Compute word count
if [[ "$1" = "-w" || "$1" = "--words" ]]; then

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
    exit
fi

# Build all. These first runs will probably generate lots of harmless error
# messages.
pdflatex "$JOB"
bibtex "$JOB"
makeglossaries "$JOB"
pdflatex "$JOB"
pdflatex "$JOB"
# Mark a clear division between the output of the first few runs and the last,
# since the errors/warnings from the last run need to be seen.
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!! LAST RUN OF LATEX !!!!!!!!!!!!!!!!!!"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
pdflatex "$JOB"

