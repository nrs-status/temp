#!/bin/bash

if [ "$#" -eq 0 ]; then
	COMMIT_MSG="autocommit $(date)"
else
	COMMIT_MSG=$@
fi

LOC=$(pwd)
nixos-rebuild switch
cd /etc/nixos
git commit -am "${COMMIT_MSG}"
cd $LOC
