#!/usr/bin/env bash

# See https://docs.python.org/3/library/http.server.html

REQUIRED_TOOLS=(
  "python"
)

DIR="output"
HOST="127.0.0.1"
PORT="8000"

for tool in ${REQUIRED_TOOLS[@]}; do
  if ! command -v ${tool} >/dev/null; then
    echo "${tool} is required ..."
    exit 1
  fi
done

echo "Preview dir ${DIR} at http://${HOST}:${PORT}"

python -m http.server ${PORT} --bind ${HOST} --directory ${DIR}
