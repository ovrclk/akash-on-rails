#!/bin/bash

set -e

echo "Restoring database"

export AWS_ACCESS_KEY_ID=$FILEBASE_KEY
export AWS_SECRET_ACCESS_KEY=$FILEBASE_SECRET
export PGPASSWORD=$POSTGRES_PASSWORD

s3_uri_base="s3://${FILEBASE_BUCKET}/backups"
aws_args="--endpoint-url https://s3.filebase.com"

if [ -z "$PASSPHRASE" ]; then
  file_type=".dump"
else
  file_type=".dump.gpg"
fi

if [ $# -eq 1 ]; then
  timestamp="$1"
  key_suffix="${POSTGRES_DATABASE}_${timestamp}${file_type}"
else
  echo "Finding latest backup..."
  key_suffix=$(
    aws $aws_args s3 ls "${s3_uri_base}/${POSTGRES_DATABASE}" \
      | sort \
      | tail -n 1 \
      | awk '{ print $4 }'
  )
fi

echo "Fetching backup from S3..."
aws $aws_args s3 cp "${s3_uri_base}/${key_suffix}" "db${file_type}"

if [ -n "$PASSPHRASE" ]; then
  echo "Decrypting backup..."
  gpg --decrypt --batch --passphrase "$PASSPHRASE" db.dump.gpg > db.dump
  rm db.dump.gpg
fi

conn_opts=""

echo "Restoring from backup..."
pg_restore --clean \
           -h postgres \
           -p 5432 \
           -U $POSTGRES_USER \
           -d $POSTGRES_DATABASE \
           $PG_RESTORE_EXTRA_OPTS \
           --if-exists db.dump
rm db.dump

echo "Restore complete."
