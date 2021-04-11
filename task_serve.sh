#!/usr/bin/env bash

source task_config.sh

REQUIRED_TOOLS=(
  "python"
)

HOST="127.0.0.1"
PORT="8000"

for tool in ${REQUIRED_TOOLS[@]}; do
  if ! command -v ${tool} >/dev/null; then
    echo "${tool} is required ..."
    exit 1
  fi
done

echo "Preview dir ${DIR} at http://${HOST}:${PORT}"

# See https://docs.python.org/3/library/http.server.html
python -m http.server ${PORT} --bind ${HOST} --directory ${DIR}
