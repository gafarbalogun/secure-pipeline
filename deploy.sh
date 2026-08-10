#!/bin/bash
set -e

# Static analysis (Bandit) — stops the deploy if it fails
./scripts/app-sec-check.sh

# Stop and remove existing container if it exists
docker stop secure-app || true
docker rm secure-app || true

# Rebuild the Docker image
docker build --no-cache -t secure-app:latest .

# Image vulnerability scan (Trivy) — stops the deploy if it fails
./scripts/image-check.sh

# Run the container
docker run -d --name secure-app -p 5050:5000 secure-app:latest

echo "✅ Deployment complete! Container is running."
