#!/bin/bash
read x
git add --all
git commit -m "$x"
git push origin master
