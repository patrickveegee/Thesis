#!/bin/bash
bibtex Thesis.aux
pdflatex Thesis.tex
open Thesis.pdf
