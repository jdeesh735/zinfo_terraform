import io
import os

from flask import Flask, send_file

app = Flask(__name__)

@app.route("/")
def serve_file():
  """Serves the file from the GCS bucket."""

  bucket_name = os.getenv("BUCKET_NAME")
  file_name = os.getenv("FILE_NAME")

  storage = StorageClient()
  bucket = storage.bucket(bucket_name)
  blob = bucket.blob(file_name)

  # Download the file from the GCS bucket.
  blob.download_to_filename("/tmp/file")

  # Open the file and send it to the client.
  with open("/tmp/file", "rb") as f:
    return send_file(f, as_attachment=False)

if __name__ == "__main__":
  app.run(host="0.0.0.0", port=80)
