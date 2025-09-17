#!/bin/bash
set -euo pipefail

unset PIP_USER || true
export PIP_DISABLE_PIP_VERSION_CHECK=1
export PIP_ROOT_USER_ACTION=ignore


if [ -f "/opt/airflow/requirements.txt" ]; then
   python -m pip install --no-cache-dir -r /opt/airflow/requirements.txt
fi

airflow db upgrade

if ! airflow users list | awk '{print $1}' | grep -qw admin; then
  airflow users create \
    --username admin \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email nguyenthihong112000@gmail.com \
    --password admin
fi

exec airflow webserver
