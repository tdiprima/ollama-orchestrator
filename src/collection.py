# nosec B105
# https://docs.openwebui.com/api/#adding-files-to-knowledge-collections
import os

import requests


def add_file_to_knowledge(token, knowledge_id, file_id):
    url = f"http://localhost:3000/api/v1/knowledge/{knowledge_id}/file/add"
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}
    data = {"file_id": file_id}
    # Return the response in JSON
    return (requests.post(url, headers=headers, json=data, timeout=30)).json()


def process_files(token, knowledge_id, directory_path):
    for filename in os.listdir(directory_path):
        if "_" in filename:
            file_id = filename.split("_")[0]  # Extract prefix as file_id
            response = add_file_to_knowledge(token, knowledge_id, file_id)
            print(f"Processed {file_id}: {response}")


# TODO:
token = ""
knowledge_id = ""
directory_path = "/var/lib/docker/volumes/open-webui/_data/uploads"

process_files(token, knowledge_id, directory_path)
