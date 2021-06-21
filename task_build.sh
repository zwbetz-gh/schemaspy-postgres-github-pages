#!/usr/bin/env bash

source task_config.sh

REQUIRED_TOOLS=(
  "java"
)

SCHEMASPY_JAR="lib/schemaspy/schemaspy-6.1.1-SNAPSHOT.jar"
# Run: java -jar lib/schemaspy/schemaspy-6.1.1-SNAPSHOT.jar -dbhelp
DATABASE_TYPE="mssql17"
JDBC_DRIVERS="lib/driver"

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
-host ${DB_HOST_LOCAL} \
-port ${DOCS_PORT_LOCAL} \
-db ${DBNAME} \
-s ${DB_SCHEMA} \
-u ${DBUSER} \
-p ${DBPASSWORD} \
-o ${DIR}

echo "Completed ${0} in ${SECONDS}s"
