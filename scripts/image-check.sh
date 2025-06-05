#!/bin/bash
echo "Scanning Docker image for vulnerabilities...
"
trivy image \
--severity HIGH,CRITICAL \
--exit-code 1 \
secure-app:latest
