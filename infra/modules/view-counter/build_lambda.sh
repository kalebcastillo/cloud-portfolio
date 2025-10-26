#!/bin/bash
set -e

# Create a temporary directory for the Lambda function
mkdir -p /tmp/lambda_build
cd /tmp/lambda_build

# Copy the Python file and rename it to index.py (required by Lambda handler)
cp /workspaces/cloud-portfolio/infra/modules/view-counter/lambda/view_counter_function.py index.py

# Create the zip file
zip -r lambda_function.zip index.py

# Copy back to the module directory
cp lambda_function.zip /workspaces/cloud-portfolio/infra/modules/view-counter/

# Cleanup
cd - > /dev/null
rm -rf /tmp/lambda_build

echo "Lambda function zip rebuilt successfully!"
