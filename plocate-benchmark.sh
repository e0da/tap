#!/bin/bash
set -ex

PLOCATE_BIN="/tmp/plocate-1.1.23-test/build-test/plocate"
UPDATEDB_BIN="/tmp/plocate-1.1.23-test/build-test/updatedb"
PLOCATE_DB="/var/db/plocate/plocate.db"
MLOCATE_DB="/var/db/locate.database"
TEST_DIR="/"

time sudo rm -f "$PLOCATE_DB" "$MLOCATE_DB"

echo ""
echo "Building native macOS locate database..."
time sudo /usr/libexec/locate.updatedb

echo ""
echo "Building plocate database with libuv..."
time sudo "$UPDATEDB_BIN" -U "$TEST_DIR" -o "$PLOCATE_DB" -l no

echo ""
echo "Searching for '.md' with native locate:"
time locate ".md" | head -5

echo ""
echo "Searching for '.md' with plocate:"
time sudo "$PLOCATE_BIN" -d "$PLOCATE_DB" ".md" | head -5

echo ""
echo "Database sizes:"
time ls -lh "$MLOCATE_DB" "$PLOCATE_DB"
