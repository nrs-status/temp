#!/bin/bash

if [ "$#" -eq 0 ]; then
	COMMIT_MSG="autocommit $(date)"
else
	COMMIT_MSG=$@
fi

LOC=$(pwd)
cd /etc/nixos
git add -A
nixos-rebuild switch
git commit -am "${COMMIT_MSG}"
cd $LOC
