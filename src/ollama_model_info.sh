#!/bin/bash
# ollama show -h

# Extract model names from ollama ls command excluding the first row (header)
model_names=$(ollama ls | tail -n +2 | cut -d' ' -f1)

# Use xargs and show --system and --temperature for each model
echo $model_names | xargs -n 1 -I{} sh -c "echo Model: {}; ollama show {} --system; echo;"
