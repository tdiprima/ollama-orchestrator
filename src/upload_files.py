# https://docs.openwebui.com/api/#uploading-files
import os

import requests


def upload_file(token, file_path):
    url = "http://localhost:3000/api/v1/files/"
    headers = {"Authorization": f"Bearer {token}", "Accept": "application/json"}
    files = {"file": open(file_path, "rb")}
    response = requests.post(url, headers=headers, files=files, timeout=30)
    files["file"].close()  # Close the file after upload
    return response.json()


def upload_files_in_directory(token, directory_path):
    # Ensure the directory exists
    if not os.path.isdir(directory_path):
        raise ValueError(f"The directory {directory_path} does not exist")

    # Loop through all files in the directory
    for filename in os.listdir(directory_path):
        file_path = os.path.join(directory_path, filename)

        # Check if it's a file (not a directory or other type)
        if os.path.isfile(file_path):
            print(f"Uploading {file_path}...")
            result = upload_file(token, file_path)
            print(f"Upload result: {result}")
        else:
            print(f"Skipping {file_path}, not a file.")


# TODO:
token = ""  # noseq B105
directory_path = "/path/to/your/dir"
upload_files_in_directory(token, directory_path)
