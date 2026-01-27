# Ollama Orchestrator

Because we're:

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
