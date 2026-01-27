#!/bin/bash

docker stop open-webui
docker rm open-webui

docker rmi ghcr.io/open-webui/open-webui:main 

# Normal
docker run -d -p 3000:8080 -e --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
