#!/bin/bash

API_URL="https://your-domain.example/api/chat/completions"

curl -X POST "$API_URL" \
-H "Authorization: Bearer $OPENWEBUI_API_KEY" \
-H "Content-Type: application/json" \
-d '{
      "model": "llama3.2:latest",
      "messages": [
        {
          "role": "user",
          "content": "Why is the sky blue?"
        }
      ]
    }'
