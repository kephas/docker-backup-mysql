#!/bin/bash


# config

USERNAME="Backup $(hostname)"
EMAIL=root@$(hostname --long)
DIR=./backup;
FILE=backup.sql


if [[ -n "$1" ]]; then
    ACTION=$1;
else
    echo "Usage: ./git-backup.sh init|save";
    exit 1;
fi

case $ACTION in
	init)
		(git init $DIR;
		 cd $DIR;
		 git config --local user.name "${USERNAME}";
		 git config --local user.email "${EMAIL}";
		 touch ${FILE};
		 git add ${FILE};
		 git commit -am "Create empty backup file");;
	save)
		(cd $DIR;
		 git commit -am "New backup";
		 for REMOTE in $(git remote); do
			 git push $REMOTE master;
		 done;);;
esac
