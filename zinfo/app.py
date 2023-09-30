from flask import Flask, Response
from google.cloud import storage

app = Flask(__name__)

def fetch_file_from_gcs(bucket_name, file_name):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    content = blob.download_as_text()
    return content

@app.route("/")
def serve_file():
    bucket_name = "zinfo-bucket"
    file_name = "sample.txt"
    file_content = fetch_file_from_gcs(bucket_name, file_name)
    return Response(file_content, mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
