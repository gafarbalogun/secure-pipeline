#!/bin/bash

# Stop and remove existing container if it exists
docker stop secure-app || true
docker rm secure-app || true

# Rebuild the Docker image
docker build --no-cache -t flask-app .

# Run the container
docker run -d --name secure-app -p 5050:5000 flask-app

echo "✅ Deployment complete! Container is running."

