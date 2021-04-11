#!/usr/bin/env bash

source task_config.sh

echo "Deleting dir ${DIR} ..."

rm -rf ${DIR}

echo "Completed ${0} in ${SECONDS}s"
