#!/bin/bash

cd $(dirname $0);
./database.sh backup
./git-backup.sh save
