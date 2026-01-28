#!/bin/bash
# Adapted for MacOS
# Inspired by Matt Williams @technovangelist

# Extract model names from ollama ls command excluding the first row (header)
model_names=$(ollama ls | tail -n +2 | cut -d' ' -f1)

# Use xargs to iterate over each model name and pull it using ollama pull command
echo $model_names | xargs -n 1 -I{} sh -c "echo Pulling model: {}; ollama pull {}"
# echo $model_names | xargs -n 1 -I{} sh -c "echo Model: {}; ollama show {} --system"
