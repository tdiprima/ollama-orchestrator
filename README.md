# Ollama Orchestrator

Managing Ollama by hand got old fast — pulling models, restarting services, wiring up UIs, and poking APIs all from the command line, one-off, every time. This repo is a collection of scripts to automate that workflow so I don't have to think about it. The problem it solves: I needed a repeatable, scriptable way to run my local AI stack without babysitting it.

"Ollama Orchestrator" because we're:

* pulling models
* inspecting models
* updating service
* wiring it to UI

Orchestrating the whole stack. 💅

## Self-hosted AI command center

Got scripts for:

- Spinning up Open WebUI + pipelines in Docker `deploy_open_webui`, `docker_run`

- Managing Ollama models (pulling, inspecting) `fetch_models_mac`, `ollama_model_info`

- Querying Open WebUI API via curl 
`query_openwebui`

- Updating Ollama + exposing it on the network via systemd edits `update_ollama_and_restart`

<br>
