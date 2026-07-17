#!/bin/bash
set -euo pipefail

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting docker prune"
docker image prune -a -f --filter "until=168h"
docker builder prune -a -f --filter "until=168h"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Done"
