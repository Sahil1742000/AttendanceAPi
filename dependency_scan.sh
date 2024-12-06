#!/bin/bash

echo "Generating the requirements.txt file using pipreqs..."
pipreqs . --force

echo "Checking installed dependencies using pipdeptree..."
pipdeptree

echo "Checking for outdated dependencies..."
pip list --outdated

echo "Checking for security vulnerabilities using safety..."
safety check

echo "Checking for broken dependencies using pip-check..."
pip-check

