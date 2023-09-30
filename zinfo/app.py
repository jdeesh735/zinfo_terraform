from google.cloud import storage

def fetch_file_from_gcs(bucket_name, file_name):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)

    # You can either return the content or serve it using a web framework like Flask.
    content = blob.download_as_text()
    return content

if __name__ == "__main__":
    bucket_name = "zinfo-bucket"
    file_name = "sample.txt"
    file_content = fetch_file_from_gcs(bucket_name, file_name)
    print(file_content)
