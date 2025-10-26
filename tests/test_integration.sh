#!/bin/bash
set -e

LAMBDA_URL="https://6r4tbovnimwq4zwdclvxyp4md40qzjet.lambda-url.us-east-1.on.aws/"
DOMAIN="https://test.kalebcastillo.com"

# Test Lambda
RESPONSE=$(curl -s -w "\n%{http_code}" "$LAMBDA_URL")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n1)

[[ "$HTTP_CODE" == "200" ]] || { echo "Lambda: HTTP $HTTP_CODE"; exit 1; }
[[ "$BODY" =~ ^[0-9]+$ ]] || { echo "Lambda: non-numeric response"; exit 1; }
echo "✅ Lambda passed (count: $BODY)"

# Test Home Page
RESPONSE=$(curl -s -w "\n%{http_code}" "$DOMAIN/")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n-1)

[[ "$HTTP_CODE" == "200" ]] || { echo "Home page: HTTP $HTTP_CODE"; exit 1; }
echo "$BODY" | grep -q "<!DOCTYPE\|<html" || { echo "Home page: invalid HTML"; exit 1; }
echo "✅ Home page passed"
