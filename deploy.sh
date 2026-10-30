#!/bin/bash
set -euo pipefail

# Build and scan the candidate before touching a running container.
./scripts/app-sec-check.sh
docker build --no-cache -t secure-app:latest .
./scripts/image-check.sh

# Only replace the local demo container after both gates pass.
if docker container inspect secure-app >/dev/null 2>&1; then
  docker stop secure-app
  docker rm secure-app
fi

docker run -d --name secure-app -p 5050:5000 secure-app:latest

echo "Local demo container is running on http://localhost:5050"
