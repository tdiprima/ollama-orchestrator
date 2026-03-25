# Ollama Orchestrator 🪄

Shell scripts and Python utilities to automate a self-hosted local AI stack — pulling models, deploying Open WebUI in Docker, keeping Ollama updated via cron, and querying the API without babysitting.

## Managing a local LLM stack manually

Every time: pull the models, restart the service, re-wire the UI, poke the API to see if it's alive. None of it is hard, but it's all manual, and it piles up. One wrong `docker run` flag and the UI can't reach Ollama. Miss an Ollama update and you're running a stale model server.

## What this repo does instead

Each script owns exactly one job. Run the one you need, skip the ones you don't. The update script runs on a cron schedule so Ollama stays current without you touching it. The Docker scripts wire Open WebUI and its pipelines container to your host Ollama instance with the right flags the first time. The Python utilities talk to the Open WebUI API directly for bulk file uploads and knowledge collection management.

## Concrete example: automated Ollama updates on Linux

```bash
# One-time setup — grants passwordless sudo for the update script only,
# then installs a cron job that runs Mon/Wed/Fri at 15:00
sudo src/update_ollama/setup_ollama_sudo.sh

# Watch the logs
journalctl -t "update_ollama" -f
```

The update script (`update_ollama`) installs the latest Ollama, ensures `OLLAMA_HOST=0.0.0.0:11434` is set in the systemd service file, reloads the daemon, restarts the service, and verifies the API responds — all without storing any passwords.

## Usage

### Deploy Open WebUI + Pipelines (Docker)

```bash
# Fresh deploy: stops and removes any existing container, then re-runs
bash src/deploy_open_webui.sh

# Or run Open WebUI + Pipelines together from scratch
bash src/docker_run.sh
```

Open WebUI will be available at `http://localhost:3000`.

### Pull or inspect local models

```bash
# Pull all models currently listed in `ollama ls`
bash src/fetch_models_mac.sh

# Print the system prompt for every local model
bash src/ollama_model_info.sh
```

### Query the Open WebUI API

```bash
# Set your API key, then send a chat completion request
export OPENWEBUI_API_KEY="your-key-here"
bash src/query_openwebui.sh
```

Edit `API_URL` and the `model` field in the script to match your deployment and desired model.

### Test the Ollama API directly

```bash
# Set HOST, PORT, and MODEL at the top of the script, then run
bash src/ollama_test.sh
```

Times the response and prints wall-clock, user, and sys CPU time.

### Upload files to Open WebUI

```python
# Set token and directory_path in upload_files.py, then run
python src/upload_files.py
```

Uploads every file in the target directory to the Open WebUI `/api/v1/files/` endpoint.

### Add uploaded files to a knowledge collection

```python
# Set token, knowledge_id, and directory_path in collection.py, then run
python src/collection.py
```

Reads filenames from the uploads directory, extracts the file ID from the filename prefix, and registers each file into the specified knowledge collection via the Open WebUI API.

### Automated Ollama updates (Linux/systemd)

```bash
# One-time setup — run once as yourself (not root)
sudo src/update_ollama/setup_ollama_sudo.sh
```

Installs a scoped sudoers entry (only this script, no password) and a crontab entry that runs the update Mon/Wed/Fri at 15:00. Logs go to `/var/log/update_ollama.log` and syslog under the tag `update_ollama`.

## Requirements

- [Ollama](https://ollama.com) installed and running
- Docker (for Open WebUI scripts)
- `curl`, `bash`
- Python 3 + `requests` (for `upload_files.py` and `collection.py`)
- Linux with systemd (for `update_ollama` and `setup_ollama_sudo.sh`)

<br>
