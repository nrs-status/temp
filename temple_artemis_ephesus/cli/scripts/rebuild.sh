#!/bin/bash

if [ "$#" -eq 0 ]; then
	COMMIT_MSG="autocommit $(date)"
else
	COMMIT_MSG=$1
fi

LOC=$(pwd)
cd /etc/nixos
git add -A
nixos-rebuild switch | tee $HOME/baghdad_plane/temp_rebuildlogs/ && git commit -am "successful nixos-rebuild; ${COMMIT_MSG}"
cd $LOC
