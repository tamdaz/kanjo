#!/bin/sh

# Migrate the database and start the server if the sqlite file is not empty.
if [ ! -s data/db.sqlite3 ]; then
    drift migrate --db sqlite3:data/db.sqlite3
    bin/kanjo
else
    echo "The database file doesn't exists. Abort."
    exit 1
fi
