#!/usr/bin/env bash

source task_config.sh

if [[ ! -f ${DOTFILE} ]]; then
  echo "File ${DOTFILE} is required ..."
  exit 1
fi

source ${DOTFILE}

psql \
-h ${PGHOST_DOCKER} \
-p ${PGPORT_DOCKER} \
< init.sql
