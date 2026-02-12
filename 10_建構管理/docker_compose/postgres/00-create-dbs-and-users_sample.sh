#!/usr/bin/env bash
set -euo pipefail

echo "==> Create databases/users (portaldb, featureA, featureB)"

# 小工具：執行一段 SQL
psql_exec() {
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" -tAc "$1"
}

create_role_if_missing() {
  local role="$1"
  local pwd="$2"
  local exists
  exists="$(psql_exec "SELECT 1 FROM pg_roles WHERE rolname='${role}'")"
  if [[ "$exists" != "1" ]]; then
    echo "==> create role: $role"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" \
      -c "CREATE ROLE ${role} LOGIN PASSWORD '${pwd}';"
  else
    echo "==> role exists: $role"
  fi
}

create_db_if_missing() {
  local db="$1"
  local owner="$2"
  local exists
  exists="$(psql_exec "SELECT 1 FROM pg_database WHERE datname='${db}'")"
  if [[ "$exists" != "1" ]]; then
    echo "==> create database: $db (owner=$owner)"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" \
      -c "CREATE DATABASE \"${db}\" OWNER \"${owner}\";"
  else
    echo "==> database exists: $db"
  fi
}

# portaldb
create_role_if_missing "${PORTAL_USER}" "${PORTAL_PASSWORD}"
create_db_if_missing "${PORTAL_DB}" "${PORTAL_USER}"

# featureA
create_role_if_missing "${FEATUREA_USER}" "${FEATUREA_PASSWORD}"
create_db_if_missing "${FEATUREA_DB}" "${FEATUREA_USER}"

# featureB
create_role_if_missing "${FEATUREB_USER}" "${FEATUREB_PASSWORD}"
create_db_if_missing "${FEATUREB_DB}" "${FEATUREB_USER}"

echo "==> Done"

