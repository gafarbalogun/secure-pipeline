#!/bin/bash

echo "Running code scan..."

bandit -r ./app -ll -f json -o security-report.json
if [ $? -eq 0 ]; then
echo "Security scan passed!"
else
echo "Security issues found. Check security-report.json"
exit 1
fi
