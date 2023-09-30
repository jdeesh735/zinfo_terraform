from google.cloud import storage

def fetch_file_from_gcs(bucket_name, file_name):
    client = storage.Client()
    bucket = client.get_bucket(bucket_name)
    blob = bucket.blob(file_name)
    
    # Optionally, you can download the file or just get its metadata
    # To download the file:
    # blob.download_to_filename("downloaded_file.txt")
    
    return blob.download_as_text()  # Returns file content as text

# Example usage
bucket_name = "zinfo-gcs-bucket"
file_name = "sample.txt"
file_content = fetch_file_from_gcs(bucket_name, file_name)
print(file_content)
