from flask import Flask, request, jsonify
from google.cloud import storage

app = Flask(__name__)

# Replace with your GCS bucket name and file name
bucket_name = 'zinfo-gcs-bucket'
file_name = 'sample.txt'

def fetch_file_contents(bucket_name, file_name):
    """Fetches the contents of a file from a GCS bucket."""
    try:
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(file_name)

        # Check if the file exists
        if not blob.exists():
            return None

        # Fetch the contents of the file
        file_contents = blob.download_as_text()

        return file_contents
    except Exception as e:
        return str(e)

@app.route('/')
def serve_file():
    try:
        file_contents = fetch_file_contents(bucket_name, file_name)

        if file_contents is not None:
            # Display the name of the file
            return f"The file name is: {file_name}"

        # File not found
        return "File not found in the GCS bucket.", 404
    except Exception as e:
        return str(e), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)

