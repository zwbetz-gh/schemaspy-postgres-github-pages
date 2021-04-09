#!/usr/bin/env bash

REQUIRED_TOOLS=(
  "java"
)

DOTFILE=".env"
SCHEMASPY_JAR="lib/schemaspy/schemaspy-6.1.0.jar"
# Run: java -jar lib/schemaspy/schemaspy-6.1.0.jar -dbhelp
# Even though we are connecting to Postgres version 13, the highest database type listed is pgsql11 ... shrug
DATABASE_TYPE="pgsql11"
JDBC_DRIVERS="lib/driver"
DIR="output"

for tool in ${REQUIRED_TOOLS[@]}; do
  if ! command -v ${tool} >/dev/null; then
    echo "${tool} is required ..."
    exit 1
  fi
done

if [[ ! -f ${DOTFILE} ]]; then
  echo "File ${DOTFILE} is required ..."
  exit 1
fi

source ${DOTFILE}

# See https://schemaspy.readthedocs.io/en/latest/configuration/commandline.html
java -jar ${SCHEMASPY_JAR} \
-debug \
-vizjs \
-nopages \
-t ${DATABASE_TYPE} \
-dp ${JDBC_DRIVERS} \
-host ${PGHOST_LOCAL} \
-port ${PGPORT_LOCAL} \
-db ${PGDATABASE} \
-s ${PGSCHEMA} \
-u ${PGUSER} \
-p ${PGPASSWORD} \
-o ${DIR}

echo "Completed ${0} in ${SECONDS}s"
