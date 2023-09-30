import io
import os
from google.cloud import storage

def get_file(bucket_name, file_name):
  """Fetches a file from a GCS bucket."""

  client = storage.Client()
  bucket = client.get_bucket(bucket_name)
  blob = bucket.blob(file_name)

  with io.BytesIO() as f:
    blob.download_to_file(f)
    return f.getvalue()


def serve_file(file_content):
  """Serves a file to clients."""

  print("Serving file...")
  print(file_content.decode())


if __name__ == "__main__":
  bucket_name = os.environ.get("GCS_BUCKET_NAME")
  file_name = os.environ.get("FILE_NAME")

  file_content = get_file(bucket_name, file_name)
  serve_file(file_content)
