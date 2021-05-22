#!/bin/bash

# Check if another instance of script is running
pidof -o %PPID -x $0 >/dev/null && echo "ERROR: Script $0 already running" && exit 1

set -e

echo "Backing up database"

export AWS_ACCESS_KEY_ID=$FILEBASE_KEY
export AWS_SECRET_ACCESS_KEY=$FILEBASE_SECRET
export PGPASSWORD=$POSTGRES_PASSWORD

pg_dump --format=custom \
        -h postgres \
        -p 5432 \
        -U $POSTGRES_USER \
        -d $POSTGRES_DATABASE \
        $PGDUMP_EXTRA_OPTS \
        > db.dump

timestamp=$(date +"%Y-%m-%dT%H:%M:%S")
s3_uri_base="s3://${FILEBASE_BUCKET}/backups/${POSTGRES_DATABASE}_${timestamp}.dump"

if [ -n "$PASSPHRASE" ]; then
  echo "Encrypting backup..."
  gpg --symmetric --batch --passphrase "$PASSPHRASE" db.dump
  rm db.dump
  local_file="db.dump.gpg"
  s3_uri="${s3_uri_base}.gpg"
else
  local_file="db.dump"
  s3_uri="$s3_uri_base"
fi

echo "Uploading backup to $FILEBASE_BUCKET..."
aws --endpoint-url https://s3.filebase.com s3 cp "$local_file" "$s3_uri"
rm "$local_file"

echo "Backup complete."
