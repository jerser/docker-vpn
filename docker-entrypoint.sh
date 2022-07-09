#!/bin/bash

echo "Starting supervisor..."
/usr/bin/supervisord --configuration=/etc/supervisord.conf --logfile=/dev/null

exec "$@"
