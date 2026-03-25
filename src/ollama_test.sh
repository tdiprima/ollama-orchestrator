#!/bin/bash

HOST=""
PORT=""
MODEL=""

echo "Testing Ollama API on $HOST..."
echo "Model: $MODEL"
echo "-----------------------------------"

# Time the curl command
# time curl -s $HOST:$PORT/api/chat -d '{
#   "model": "$MODEL",
#   "messages": [{"role": "user", "content": "Hello, are you working?"}],
#   "stream": false
# }'

# Set timeout
time curl -s --max-time 60 $HOST:$PORT/api/chat -d '{
  "model": "$MODEL",
  "messages": [{"role": "user", "content": "Hello, are you working?"}],
  "stream": false
}'

echo ""
echo "-----------------------------------"
echo "Times shown above: real = wall clock, user = CPU in user mode, sys = CPU in kernel mode"
