#!/bin/bash
repository=${PWD##*/}
commitm=$1
if [ "$1" = "" ]; then
	commitm="Automatic Upload"

fi

git add .
git commit -m "$commitm" -a
git push "https://github.com/xXHeroooreHXx/$repository"
git status