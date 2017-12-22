#!/bin/bash


# config

PASSWORD=PASSWORD;
USERNAME=USERNAME;
DATABASE=DATABASE;

CONTAINER=CONTAINER;



if [[ -n "$1" ]]; then
    ACTION=$1;
else
    echo "Usage: ./database.sh backup|restore [version]";
    exit 1;
fi

if [[ -n "$2" ]]; then
    VERSION="-$2";
	DATE_OPT="";
else
    VERSION="";
	DATE_OPT="--skip-dump-date";
fi;


FILE=./backup/backup${VERSION}.sql;
AUTH="--user=${USERNAME} --password=${PASSWORD} ";

PID=$(docker inspect --format '{{.State.Pid}}' $CONTAINER)


run_in_container() {
    nsenter -t $PID -m -u -i -p /bin/bash -c "$1";
}


case $ACTION in
    backup)
		COMMAND="mysqldump ${DATE_OPT} ${AUTH} --databases ${DATABASE}";
		run_in_container "$COMMAND" > "$FILE";;
    restore)
		COMMAND="mysql ${AUTH} ${DATABASE}";
		run_in_container "$COMMAND" < "$FILE";;
esac;
