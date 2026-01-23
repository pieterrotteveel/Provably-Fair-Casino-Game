#!/bin/bash

echo "Testing API..."
if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "❌ Server not running!"
    echo "Start server first: ./START_SERVER.sh"
    exit 1
fi

echo "Creating game..."
curl -X POST http://localhost:3000/api/v1/towers/create \
  -H "Content-Type: application/json" \
  -d '{"bet_amount": "10.0", "difficulty": "medium"}'
echo ""
