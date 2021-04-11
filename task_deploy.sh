#!/usr/bin/env bash

source task_config.sh

REQUIRED_TOOLS=(
  "ghp-import"
)

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
MAIN_BRANCH="main"

HASH=$(git rev-parse --short HEAD)
COMMIT_MSG="Deploy git hash ${HASH}"

for tool in ${REQUIRED_TOOLS[@]}; do
  if ! command -v ${tool} >/dev/null; then
    echo "${tool} is required ..."
    exit 1
  fi
done

if [[ ${CURRENT_BRANCH} == ${MAIN_BRANCH} ]]; then
  echo "Current branch is ${MAIN_BRANCH}, you're good to go"
else
  echo "Only the ${MAIN_BRANCH} branch can be deployed ..."
  exit 1
fi

if [[ ! -d ${DIR} ]]; then
  echo "${DIR} dir must exist before deploying ..."
  exit 1
fi

echo ${COMMIT_MSG}

ghp-import -n -p -f -m "${COMMIT_MSG}" ${DIR}

echo "Completed ${0} in ${SECONDS}s"
