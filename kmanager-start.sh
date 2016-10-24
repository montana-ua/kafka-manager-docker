#!/bin/sh

if [[ -f /opt/kafka-manager/RUNNING_PID ]] && [[ -z $(lsof -i :9000 | tail -1 | awk '{print $2}') ]]; then rm -rf /opt/kafka-manager/RUNNING_PID; fi

exec ./bin/kafka-manager -Dconfig.file=${KMANAGER_CONFIG} -Dapplication.home=./ "${KMANAGER_ARGS}" "${@}"
